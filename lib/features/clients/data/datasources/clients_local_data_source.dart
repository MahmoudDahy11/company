import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' hide Client;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/client_details_data.dart';
import '../../domain/entities/client_list_item.dart';
import '../../domain/entities/client_model_entry.dart';
import '../../domain/entities/client_payment_entry.dart';
import '../../domain/entities/client_summary.dart';

@lazySingleton
class ClientsLocalDataSource {
  ClientsLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<ClientListItem>> watchClients(DateTime month) {
    // We use a custom select to fetch all summaries in a single query (optimized)
    // while maintaining reactivity by watching the relevant tables.
    final monthRange = _monthRange(month);

    return _database
        .customSelect(
          '''
      SELECT 
        c.id, 
        c.name,
        (SELECT SUM(cm.piece_count * cm.price_per_piece) 
         FROM client_models cm 
         WHERE cm.client_id = c.id AND cm.date BETWEEN ? AND ?) as month_amount,
        (SELECT SUM(cp.amount) 
         FROM client_payments cp 
         WHERE cp.client_id = c.id AND cp.payment_date BETWEEN ? AND ?) as month_paid,
        (SELECT SUM(cm2.piece_count * cm2.price_per_piece) 
         FROM client_models cm2 
         WHERE cm2.client_id = c.id AND cm2.date <= ?) as total_amount_all_time,
        (SELECT SUM(cp2.amount) 
         FROM client_payments cp2 
         WHERE cp2.client_id = c.id AND cp2.payment_date <= ?) as total_paid_all_time
      FROM clients c
      WHERE c.is_active = 1
      ORDER BY c.name ASC
      ''',
          variables: [
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
            Variable.withDateTime(monthRange.end),
            Variable.withDateTime(monthRange.end),
          ],
          readsFrom: {
            _database.clients,
            _database.clientModels,
            _database.clientPayments,
          },
        )
        .watch()
        .map((rows) {
          return rows.map((row) {
            final monthAmount = row.read<double?>('month_amount') ?? 0.0;
            final monthPaid = row.read<double?>('month_paid') ?? 0.0;
            final totalAmountAllTime =
                row.read<double?>('total_amount_all_time') ?? 0.0;
            final totalPaidAllTime =
                row.read<double?>('total_paid_all_time') ?? 0.0;

            return ClientListItem(
              id: row.read<int>('id'),
              name: row.read<String>('name'),
              totalAmount: monthAmount,
              totalPaid: monthPaid,
              outstanding: totalAmountAllTime - totalPaidAllTime,
            );
          }).toList();
        });
  }

  Stream<ClientDetailsData> watchClientDetails(int clientId, DateTime month) {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.clients,
            _database.clientModels,
            _database.clientPayments,
          },
        )
        .watch()
        .asyncMap((_) => _buildClientDetails(clientId, month));
  }

  Future<void> addClient({required String name, String? phone}) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.clients)
          .insert(
            ClientsCompanion.insert(
              name: name.trim(),
              phone: Value(
                phone?.trim().isEmpty == true ? null : phone?.trim(),
              ),
            ),
          );
      final client = await (_database.select(
        _database.clients,
      )..where((t) => t.id.equals(id))).getSingle();
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'clients',
        recordId: id,
        payload: client.toJson(),
      );
    });
  }

  Future<void> deleteClient(int clientId) async {
    final existing = await (_database.select(
      _database.clients,
    )..where((t) => t.id.equals(clientId))).getSingleOrNull();
    if (existing == null) return;

    await _database.transaction(() async {
      await (_database.update(_database.clients)
            ..where((t) => t.id.equals(clientId)))
          .write(const ClientsCompanion(isActive: Value(false)));

      final updated = await (_database.select(
        _database.clients,
      )..where((t) => t.id.equals(clientId))).getSingle();
      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'clients',
        recordId: clientId,
        payload: updated.toJson(),
      );
    });
  }

  Future<void> addModel({
    required int clientId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.clientModels)
          .insert(
            ClientModelsCompanion.insert(
              clientId: clientId,
              modelName: modelName.trim(),
              pieceCount: pieceCount,
              pricePerPiece: pricePerPiece,
              date: date,
              notes: Value(notes),
            ),
          );
      final model = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(id))).getSingle();
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'client_models',
        recordId: id,
        payload: model.toJson(),
      );
    });
  }

  Future<void> updateModel({
    required int modelId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).getSingleOrNull();
      if (existing == null) return;

      await (_database.update(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).write(
        ClientModelsCompanion(
          modelName: Value(modelName.trim()),
          pieceCount: Value(pieceCount),
          pricePerPiece: Value(pricePerPiece),
          date: Value(date),
          notes: Value(notes),
        ),
      );

      final updated = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).getSingle();
      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'client_models',
        recordId: modelId,
        payload: updated.toJson(),
      );
    });
  }

  Future<void> deleteModel(int modelId) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).getSingleOrNull();
      if (row == null) return;

      await (_database.delete(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).go();

      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'client_models',
        recordId: modelId,
        payload: {'id': modelId, 'clientId': row.clientId},
      );
    });
  }

  Future<void> addPayment({
    required int clientId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.clientPayments)
          .insert(
            ClientPaymentsCompanion.insert(
              clientId: clientId,
              amount: amount,
              paymentDate: paymentDate,
              notes: Value(notes),
            ),
          );
      final payment = await (_database.select(
        _database.clientPayments,
      )..where((t) => t.id.equals(id))).getSingle();
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'client_payments',
        recordId: id,
        payload: payment.toJson(),
      );
    });
  }

  Future<void> updatePayment({
    required int paymentId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.clientPayments,
      )..where((t) => t.id.equals(paymentId))).getSingleOrNull();
      if (existing == null) return;

      await (_database.update(
        _database.clientPayments,
      )..where((t) => t.id.equals(paymentId))).write(
        ClientPaymentsCompanion(
          amount: Value(amount),
          paymentDate: Value(paymentDate),
          notes: Value(notes),
        ),
      );

      final updated = await (_database.select(
        _database.clientPayments,
      )..where((t) => t.id.equals(paymentId))).getSingle();
      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'client_payments',
        recordId: paymentId,
        payload: updated.toJson(),
      );
    });
  }

  Future<void> deletePayment(int paymentId) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.clientPayments,
      )..where((t) => t.id.equals(paymentId))).getSingleOrNull();
      if (row == null) return;

      await (_database.delete(
        _database.clientPayments,
      )..where((t) => t.id.equals(paymentId))).go();

      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'client_payments',
        recordId: paymentId,
        payload: {'id': paymentId, 'clientId': row.clientId},
      );
    });
  }

  Future<ClientDetailsData> _buildClientDetails(
    int clientId,
    DateTime month,
  ) async {
    final clientRow = await (_database.select(
      _database.clients,
    )..where((t) => t.id.equals(clientId))).getSingle();
    final summary = await _buildClientSummary(clientId, month);
    final monthRange = _monthRange(month);

    final modelsRows =
        await (_database.select(_database.clientModels)
              ..where(
                (t) =>
                    t.clientId.equals(clientId) &
                    t.date.isBetweenValues(monthRange.start, monthRange.end),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.date)]))
            .get();

    final paymentsRows =
        await (_database.select(_database.clientPayments)
              ..where(
                (t) =>
                    t.clientId.equals(clientId) &
                    t.paymentDate.isBetweenValues(
                      monthRange.start,
                      monthRange.end,
                    ),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]))
            .get();

    return ClientDetailsData(
      client: Client(
        id: clientRow.id,
        name: clientRow.name,
        phone: clientRow.phone,
        createdAt: clientRow.createdAt,
        isActive: clientRow.isActive,
      ),
      summary: summary,
      models: modelsRows
          .map(
            (row) => ClientModelEntry(
              id: row.id,
              clientId: row.clientId,
              modelName: row.modelName,
              pieceCount: row.pieceCount,
              pricePerPiece: row.pricePerPiece,
              date: row.date,
              notes: row.notes,
            ),
          )
          .toList(),
      payments: paymentsRows
          .map(
            (row) => ClientPaymentEntry(
              id: row.id,
              clientId: row.clientId,
              amount: row.amount,
              paymentDate: row.paymentDate,
              notes: row.notes,
            ),
          )
          .toList(),
    );
  }

  Future<ClientSummary> _buildClientSummary(
    int clientId,
    DateTime month,
  ) async {
    final monthRange = _monthRange(month);

    final amountExp =
        (_database.clientModels.pieceCount.cast<double>() *
                _database.clientModels.pricePerPiece)
            .sum();
    final monthModelsQuery = _database.selectOnly(_database.clientModels)
      ..addColumns([amountExp])
      ..where(
        _database.clientModels.clientId.equals(clientId) &
            _database.clientModels.date.isBetweenValues(
              monthRange.start,
              monthRange.end,
            ),
      );

    final paymentSumExp = _database.clientPayments.amount.sum();
    final monthPaymentsQuery = _database.selectOnly(_database.clientPayments)
      ..addColumns([paymentSumExp])
      ..where(
        _database.clientPayments.clientId.equals(clientId) &
            _database.clientPayments.paymentDate.isBetweenValues(
              monthRange.start,
              monthRange.end,
            ),
      );

    final totalAmountExp =
        (_database.clientModels.pieceCount.cast<double>() *
                _database.clientModels.pricePerPiece)
            .sum();
    final totalModelsQuery = _database.selectOnly(_database.clientModels)
      ..addColumns([totalAmountExp])
      ..where(
        _database.clientModels.clientId.equals(clientId) &
            _database.clientModels.date.isSmallerOrEqualValue(monthRange.end),
      );

    final totalPaymentsSumExp = _database.clientPayments.amount.sum();
    final totalPaymentsQuery = _database.selectOnly(_database.clientPayments)
      ..addColumns([totalPaymentsSumExp])
      ..where(
        _database.clientPayments.clientId.equals(clientId) &
            _database.clientPayments.paymentDate.isSmallerOrEqualValue(
              monthRange.end,
            ),
      );

    final monthAmount = await monthModelsQuery
        .map((row) => row.read(amountExp))
        .getSingleOrNull();
    final monthPaid = await monthPaymentsQuery
        .map((row) => row.read(paymentSumExp))
        .getSingleOrNull();
    final totalAmount = await totalModelsQuery
        .map((row) => row.read(totalAmountExp))
        .getSingleOrNull();
    final totalPaid = await totalPaymentsQuery
        .map((row) => row.read(totalPaymentsSumExp))
        .getSingleOrNull();

    return ClientSummary(
      totalAmount: (monthAmount ?? 0.0).toDouble(),
      totalPaid: (monthPaid ?? 0.0).toDouble(),
      outstanding:
          (totalAmount ?? 0.0).toDouble() - (totalPaid ?? 0.0).toDouble(),
    );
  }

  Future<void> _queueSync({
    required SyncQueueOperation operation,
    required String tableName,
    required int recordId,
    required Map<String, dynamic> payload,
  }) {
    return _database
        .into(_database.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            operation: operation,
            targetTableName: tableName,
            recordId: recordId,
            payload: jsonEncode(payload),
          ),
        );
  }

  ({DateTime start, DateTime end}) _monthRange(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
    return (start: start, end: end);
  }
}
