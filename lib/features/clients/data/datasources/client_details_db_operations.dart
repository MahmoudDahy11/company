import 'dart:async';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' hide Client;
import '../../domain/entities/client.dart';
import '../../domain/entities/client_details_data.dart';
import '../../domain/entities/client_model_entry.dart';
import '../../domain/entities/client_payment_entry.dart';
import '../../domain/entities/client_summary.dart';
import 'db_helpers.dart';

class DetailsDbOperations {
  DetailsDbOperations(this._database);
  final AppDatabase _database;

  Stream<ClientDetailsData> watchClientDetails(int clientId, DateTime month) =>
      _database
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

  Future<ClientDetailsData> _buildClientDetails(
    int clientId,
    DateTime month,
  ) async {
    final clientRow = await (_database.select(
      _database.clients,
    )..where((t) => t.id.equals(clientId))).getSingle();
    final summary = await _buildClientSummary(clientId, month);
    final range = monthRange(month);
    final modelsRows =
        await (_database.select(_database.clientModels)
              ..where(
                (t) =>
                    t.clientId.equals(clientId) &
                    t.date.isBetweenValues(range.start, range.end),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.date)]))
            .get();
    final paymentsRows =
        await (_database.select(_database.clientPayments)
              ..where(
                (t) =>
                    t.clientId.equals(clientId) &
                    t.paymentDate.isBetweenValues(range.start, range.end),
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
            (r) => ClientModelEntry(
              id: r.id,
              clientId: r.clientId,
              modelName: r.modelName,
              pieceCount: r.pieceCount,
              pricePerPiece: r.pricePerPiece,
              date: r.date,
              notes: r.notes,
            ),
          )
          .toList(),
      payments: paymentsRows
          .map(
            (r) => ClientPaymentEntry(
              id: r.id,
              clientId: r.clientId,
              amount: r.amount,
              paymentDate: r.paymentDate,
              notes: r.notes,
            ),
          )
          .toList(),
    );
  }

  Future<ClientSummary> _buildClientSummary(
    int clientId,
    DateTime month,
  ) async {
    final range = monthRange(month);
    final monthAmount = await _sumModels(
      clientId,
      start: range.start,
      end: range.end,
    );
    final monthPaid = await _sumPayments(
      clientId,
      start: range.start,
      end: range.end,
    );
    final totalAmount = await _sumModels(clientId, end: range.end);
    final totalPaid = await _sumPayments(clientId, end: range.end);
    return ClientSummary(
      totalAmount: (monthAmount ?? 0).toDouble(),
      totalPaid: (monthPaid ?? 0).toDouble(),
      outstanding: ((totalAmount ?? 0) - (totalPaid ?? 0)).toDouble(),
    );
  }

  Future<double?> _sumModels(
    int clientId, {
    DateTime? start,
    required DateTime end,
  }) {
    final exp =
        (_database.clientModels.pieceCount.cast<double>() *
                _database.clientModels.pricePerPiece)
            .sum();
    final query = _database.selectOnly(_database.clientModels)
      ..addColumns([exp]);
    if (start != null) {
      query.where(
        _database.clientModels.clientId.equals(clientId) &
            _database.clientModels.date.isBetweenValues(start, end),
      );
    } else {
      query.where(
        _database.clientModels.clientId.equals(clientId) &
            _database.clientModels.date.isSmallerOrEqualValue(end),
      );
    }
    return query.map((r) => r.read(exp)).getSingleOrNull();
  }

  Future<double?> _sumPayments(
    int clientId, {
    DateTime? start,
    required DateTime end,
  }) {
    final exp = _database.clientPayments.amount.sum();
    final query = _database.selectOnly(_database.clientPayments)
      ..addColumns([exp]);
    if (start != null) {
      query.where(
        _database.clientPayments.clientId.equals(clientId) &
            _database.clientPayments.paymentDate.isBetweenValues(start, end),
      );
    } else {
      query.where(
        _database.clientPayments.clientId.equals(clientId) &
            _database.clientPayments.paymentDate.isSmallerOrEqualValue(end),
      );
    }
    return query.map((r) => r.read(exp)).getSingleOrNull();
  }
}
