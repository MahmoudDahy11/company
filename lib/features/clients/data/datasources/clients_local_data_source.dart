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
    return _watchTrigger().asyncMap((_) => _buildClientsList(month));
  }

  Stream<ClientDetailsData> watchClientDetails(int clientId, DateTime month) {
    return _watchTrigger().asyncMap(
      (_) => _buildClientDetails(clientId, month),
    );
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
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'clients',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'name': name.trim(),
          'phone': phone?.trim(),
          'createdAt': DateTime.now().toIso8601String(),
          'isActive': true,
        },
      );
    });
  }

  Future<void> deleteClient(int clientId) async {
    final existing = await (_database.select(
      _database.clients,
    )..where((t) => t.id.equals(clientId))).getSingleOrNull();
    if (existing == null) {
      return;
    }

    await _database.transaction(() async {
      await (_database.update(_database.clients)
            ..where((t) => t.id.equals(clientId)))
          .write(const ClientsCompanion(isActive: Value(false)));
      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'clients',
        recordId: clientId,
        payload: <String, dynamic>{
          'id': existing.id,
          'name': existing.name,
          'phone': existing.phone,
          'createdAt': existing.createdAt.toIso8601String(),
          'isActive': false,
        },
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
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'client_models',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'clientId': clientId,
          'modelName': modelName.trim(),
          'pieceCount': pieceCount,
          'pricePerPiece': pricePerPiece,
          'date': date.toIso8601String(),
          'notes': notes,
        },
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
      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'client_models',
        recordId: modelId,
        payload: <String, dynamic>{
          'id': modelId,
          'clientId': existing.clientId,
          'modelName': modelName.trim(),
          'pieceCount': pieceCount,
          'pricePerPiece': pricePerPiece,
          'date': date.toIso8601String(),
          'notes': notes,
        },
      );
    });
  }

  Future<void> deleteModel(int modelId) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).getSingleOrNull();
      if (row == null) {
        return;
      }
      await (_database.delete(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).go();
      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'client_models',
        recordId: modelId,
        payload: <String, dynamic>{'id': modelId, 'clientId': row.clientId},
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
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'client_payments',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'clientId': clientId,
          'amount': amount,
          'paymentDate': paymentDate.toIso8601String(),
          'notes': notes,
        },
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
      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'client_payments',
        recordId: paymentId,
        payload: <String, dynamic>{
          'id': paymentId,
          'clientId': existing.clientId,
          'amount': amount,
          'paymentDate': paymentDate.toIso8601String(),
          'notes': notes,
        },
      );
    });
  }

  Future<void> deletePayment(int paymentId) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.clientPayments,
      )..where((t) => t.id.equals(paymentId))).getSingleOrNull();
      if (row == null) {
        return;
      }
      await (_database.delete(
        _database.clientPayments,
      )..where((t) => t.id.equals(paymentId))).go();
      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'client_payments',
        recordId: paymentId,
        payload: <String, dynamic>{'id': paymentId, 'clientId': row.clientId},
      );
    });
  }

  Stream<List<QueryRow>> _watchTrigger() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.clients,
            _database.clientModels,
            _database.clientPayments,
          },
        )
        .watch();
  }

  Future<List<ClientListItem>> _buildClientsList(DateTime month) async {
    final rows =
        await (_database.select(_database.clients)
              ..where((t) => t.isActive.equals(true))
              ..orderBy([(t) => OrderingTerm(expression: t.name)]))
            .get();
    final result = <ClientListItem>[];
    for (final row in rows) {
      final summary = await _buildClientSummary(row.id, month);
      result.add(
        ClientListItem(
          id: row.id,
          name: row.name,
          totalAmount: summary.totalAmount,
          totalPaid: summary.totalPaid,
          outstanding: summary.outstanding,
        ),
      );
    }
    return result;
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
    final modelsRows =
        await (_database.select(_database.clientModels)..where(
              (t) =>
                  t.clientId.equals(clientId) &
                  t.date.isBetweenValues(monthRange.start, monthRange.end),
            ))
            .get();
    final paymentsRows =
        await (_database.select(_database.clientPayments)..where(
              (t) =>
                  t.clientId.equals(clientId) &
                  t.paymentDate.isBetweenValues(
                    monthRange.start,
                    monthRange.end,
                  ),
            ))
            .get();
    final totalAmount = modelsRows.fold<double>(
      0,
      (sum, row) => sum + (row.pieceCount * row.pricePerPiece),
    );
    final totalPaid = paymentsRows.fold<double>(
      0,
      (sum, row) => sum + row.amount,
    );
    return ClientSummary(
      totalAmount: totalAmount,
      totalPaid: totalPaid,
      outstanding: totalAmount - totalPaid,
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
