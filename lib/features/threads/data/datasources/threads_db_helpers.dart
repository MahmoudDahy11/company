import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/supplier_summary.dart';

({DateTime start, DateTime end}) monthRange(DateTime month) {
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
  return (start: start, end: end);
}

Stream<List<QueryRow>> watchTrigger(AppDatabase database) {
  return database
      .customSelect(
        'SELECT 1',
        readsFrom: {
          database.suppliers,
          database.threadPurchases,
          database.supplierPayments,
        },
      )
      .watch();
}

Future<void> queueSync({
  required AppDatabase database,
  required SyncQueueOperation operation,
  required String tableName,
  required int recordId,
  required Map<String, dynamic> payload,
}) {
  return database
      .into(database.syncQueue)
      .insert(
        SyncQueueCompanion.insert(
          operation: operation,
          targetTableName: tableName,
          recordId: recordId,
          payload: jsonEncode(payload),
        ),
      );
}

Future<SupplierSummary> buildSupplierSummary({
  required AppDatabase database,
  required int supplierId,
  required DateTime month,
}) async {
  final range = monthRange(month);
  final purchaseRows =
      await (database.select(database.threadPurchases)..where(
            (t) =>
                t.supplierId.equals(supplierId) &
                t.purchaseDate.isBetweenValues(range.start, range.end),
          ))
          .get();
  final paymentRows =
      await (database.select(database.supplierPayments)..where(
            (t) =>
                t.supplierId.equals(supplierId) &
                t.paymentDate.isBetweenValues(range.start, range.end),
          ))
          .get();
  final totalPurchased = purchaseRows.fold<double>(
    0,
    (sum, row) => sum + row.price,
  );
  final totalPaid = paymentRows.fold<double>(0, (sum, row) => sum + row.amount);
  return SupplierSummary(
    totalPurchased: totalPurchased,
    totalPaid: totalPaid,
    outstandingBalance: totalPurchased - totalPaid,
  );
}
