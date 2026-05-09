import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide Supplier, ThreadPurchase;
import '../../../../core/sync/sync_queue_table.dart';
import 'threads_db_helpers.dart';

@lazySingleton
class PaymentsLocalDataSource {
  PaymentsLocalDataSource(this._database);

  final AppDatabase _database;

  Future<void> addPayment({
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.supplierPayments)
          .insert(
            SupplierPaymentsCompanion.insert(
              supplierId: supplierId,
              amount: amount,
              paymentDate: paymentDate,
              notes: Value(notes),
            ),
          );
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.insert,
        tableName: 'supplier_payments',
        recordId: id,
        payload: _paymentPayload(
          id: id,
          supplierId: supplierId,
          amount: amount,
          paymentDate: paymentDate,
          notes: notes,
        ),
      );
    });
  }

  Future<void> addOrUpdatePayment({
    int? paymentId,
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) async {
    await _database.transaction(() async {
      late final int id;
      late final SyncQueueOperation operation;
      final companion = SupplierPaymentsCompanion(
        supplierId: Value(supplierId),
        amount: Value(amount),
        paymentDate: Value(paymentDate),
        notes: Value(notes),
      );

      if (paymentId == null) {
        id = await _database
            .into(_database.supplierPayments)
            .insert(
              SupplierPaymentsCompanion.insert(
                supplierId: supplierId,
                amount: amount,
                paymentDate: paymentDate,
                notes: Value(notes),
              ),
            );
        operation = SyncQueueOperation.insert;
      } else {
        await (_database.update(
          _database.supplierPayments,
        )..where((table) => table.id.equals(paymentId))).write(companion);
        id = paymentId;
        operation = SyncQueueOperation.update;
      }

      await queueSync(
        database: _database,
        operation: operation,
        tableName: 'supplier_payments',
        recordId: id,
        payload: _paymentPayload(
          id: id,
          supplierId: supplierId,
          amount: amount,
          paymentDate: paymentDate,
          notes: notes,
        ),
      );
    });
  }

  Future<void> deletePayment(int paymentId) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.supplierPayments,
      )..where((t) => t.id.equals(paymentId))).getSingleOrNull();
      if (row == null) return;
      await (_database.delete(
        _database.supplierPayments,
      )..where((t) => t.id.equals(paymentId))).go();
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.delete,
        tableName: 'supplier_payments',
        recordId: paymentId,
        payload: <String, dynamic>{
          'id': paymentId,
          'supplierId': row.supplierId,
        },
      );
    });
  }

  Map<String, dynamic> _paymentPayload({
    required int id,
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => <String, dynamic>{
    'id': id,
    'supplierId': supplierId,
    'amount': amount,
    'paymentDate': paymentDate.toIso8601String(),
    'notes': notes,
  };
}
