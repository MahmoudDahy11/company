import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart'
    hide Supplier, ThreadPurchase;
import '../../domain/entities/supplier.dart';
import '../../domain/entities/supplier_details_data.dart';
import '../../domain/entities/supplier_payment.dart';
import '../../domain/entities/thread_purchase.dart';
import 'threads_db_helpers.dart';

Future<SupplierDetailsData> buildSupplierDetailsData({
  required AppDatabase database,
  required int supplierId,
  required DateTime month,
}) async {
  final supplierRow = await (database.select(
    database.suppliers,
  )..where((t) => t.id.equals(supplierId))).getSingle();
  final summary = await buildSupplierSummary(
    database: database,
    supplierId: supplierId,
    month: month,
  );
  final range = monthRange(month);

  final purchaseRows =
      await (database.select(database.threadPurchases)
            ..where(
              (t) =>
                  t.supplierId.equals(supplierId) &
                  t.purchaseDate.isBetweenValues(range.start, range.end),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]))
          .get();
  final paymentRows =
      await (database.select(database.supplierPayments)
            ..where(
              (t) =>
                  t.supplierId.equals(supplierId) &
                  t.paymentDate.isBetweenValues(range.start, range.end),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]))
          .get();

  return SupplierDetailsData(
    supplier: Supplier(
      id: supplierRow.id,
      name: supplierRow.name,
      phone: supplierRow.phone,
      createdAt: supplierRow.createdAt,
    ),
    summary: summary,
    purchases: purchaseRows
        .map(
          (row) => ThreadPurchase(
            id: row.id,
            supplierId: row.supplierId,
            itemName: row.itemName,
            colorNumber: row.colorNumber,
            purchaseDate: row.purchaseDate,
            price: row.price,
            quantity: row.quantity,
            unit: row.unit,
            notes: row.notes,
          ),
        )
        .toList(),
    payments: paymentRows
        .map(
          (row) => SupplierPaymentEntry(
            id: row.id,
            supplierId: row.supplierId,
            amount: row.amount,
            paymentDate: row.paymentDate,
            notes: row.notes,
          ),
        )
        .toList(),
  );
}
