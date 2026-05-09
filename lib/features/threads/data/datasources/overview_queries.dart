import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/threads_overview.dart';
import 'threads_db_helpers.dart';

Future<ThreadsOverview> buildThreadsOverview({
  required AppDatabase database,
  required DateTime month,
}) async {
  final range = monthRange(month);
  final yearStart = DateTime(month.year);
  final yearEnd = DateTime(month.year, 12, 31, 23, 59, 59, 999);
  final supplierIds = (await database.select(database.suppliers).get())
      .map((s) => s.id)
      .toSet();

  final monthPurchases =
      await (database.select(database.threadPurchases)..where(
            (t) => t.purchaseDate.isBetweenValues(range.start, range.end),
          ))
          .get();
  final yearPurchases = await (database.select(
    database.threadPurchases,
  )..where((t) => t.purchaseDate.isBetweenValues(yearStart, yearEnd))).get();
  final yearPayments = await (database.select(
    database.supplierPayments,
  )..where((t) => t.paymentDate.isBetweenValues(yearStart, yearEnd))).get();
  final allPurchases = await database.select(database.threadPurchases).get();
  final allPayments = await database.select(database.supplierPayments).get();

  final activeMonthPurchases = monthPurchases
      .where((r) => supplierIds.contains(r.supplierId))
      .toList();
  final activeYearPurchases = yearPurchases
      .where((r) => supplierIds.contains(r.supplierId))
      .toList();
  final activeYearPayments = yearPayments
      .where((r) => supplierIds.contains(r.supplierId))
      .toList();
  final activeAllPurchases = allPurchases
      .where((r) => supplierIds.contains(r.supplierId))
      .toList();
  final activeAllPayments = allPayments
      .where((r) => supplierIds.contains(r.supplierId))
      .toList();

  return ThreadsOverview(
    monthlyPurchased: activeMonthPurchases.fold<double>(
      0,
      (s, r) => s + r.price,
    ),
    yearlyPurchased: activeYearPurchases.fold<double>(0, (s, r) => s + r.price),
    yearlyPaid: activeYearPayments.fold<double>(0, (s, r) => s + r.amount),
    totalOutstanding:
        activeAllPurchases.fold<double>(0, (s, r) => s + r.price) -
        activeAllPayments.fold<double>(0, (s, r) => s + r.amount),
  );
}
