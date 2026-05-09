import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' hide Client;
import '../../../../core/sync/sync_queue_table.dart';
import 'db_helpers.dart';

class PaymentDbOperations {
  PaymentDbOperations(this._database);

  final AppDatabase _database;

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
      await queueSyncEntry(
        _database,
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
      await queueSyncEntry(
        _database,
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

      await queueSyncEntry(
        _database,
        operation: SyncQueueOperation.delete,
        tableName: 'client_payments',
        recordId: paymentId,
        payload: {'id': paymentId, 'clientId': row.clientId},
      );
    });
  }
}
