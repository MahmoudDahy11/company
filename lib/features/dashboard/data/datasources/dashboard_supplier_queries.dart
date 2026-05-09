import 'dart:developer';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_summary.dart';

class DashboardSupplierQueries {
  const DashboardSupplierQueries(this._database);

  final AppDatabase _database;

  Future<(List<SupplierAnnualSummary> summaries, double totalDue)>
  fetchSupplierData(({DateTime start, DateTime end}) range) async {
    final rows = await _database
        .customSelect(
          '''
      SELECT s.id, s.name,
        COALESCE(SUM(p.price), 0.0) as total_purchased,
        COALESCE((SELECT SUM(amount) FROM supplier_payments WHERE supplier_id = s.id AND payment_date BETWEEN ? AND ?), 0.0) as total_paid
      FROM suppliers s
      LEFT JOIN thread_purchases p ON s.id = p.supplier_id AND p.purchase_date BETWEEN ? AND ?
      GROUP BY s.id ORDER BY (total_purchased - total_paid) DESC
      ''',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
          ],
        )
        .get();

    double totalDue = 0;
    final summaries = <SupplierAnnualSummary>[];
    for (final row in rows) {
      final purchased = row.read<double?>('total_purchased') ?? 0.0;
      final paid = row.read<double?>('total_paid') ?? 0.0;
      final remaining = purchased - paid;
      totalDue += remaining;
      summaries.add(
        SupplierAnnualSummary(
          supplierId: row.read<int?>('id') ?? 0,
          name: row.read<String?>('name') ?? '',
          totalPurchases: purchased,
          totalPaid: paid,
          remaining: remaining,
        ),
      );
    }
    log('DEBUG: Dashboard: Total Due to Suppliers: $totalDue');
    return (summaries, totalDue);
  }

  Future<List<DashboardLinePoint>> fetchThreadPurchasesByYear(int year) async {
    final yearStart = DateTime(year, 1, 1);
    final yearEnd = DateTime(year, 12, 31, 23, 59, 59);
    final all = await (_database.select(
      _database.threadPurchases,
    )..where((t) => t.purchaseDate.isBetweenValues(yearStart, yearEnd))).get();

    return List.generate(12, (i) {
      final monthIdx = i + 1;
      final total = all
          .where((p) => p.purchaseDate.month == monthIdx)
          .fold<double>(0, (sum, p) => sum + p.price);
      return DashboardLinePoint(month: monthIdx, value: total);
    });
  }

  Future<double> fetchMaintenanceCost(
    ({DateTime start, DateTime end}) range,
  ) async {
    final row = await _database
        .customSelect(
          'SELECT COALESCE(SUM(total_cost), 0.0) as total_cost FROM maintenance_fault_records WHERE created_at BETWEEN ? AND ?',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
          ],
        )
        .getSingle();
    return row.read<double?>('total_cost') ?? 0.0;
  }
}
