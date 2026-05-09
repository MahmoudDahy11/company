import 'dart:developer';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_summary.dart';

class DashboardWorkerQueries {
  const DashboardWorkerQueries(this._database);

  final AppDatabase _database;

  Future<({int count, double earnings, double deductions})> fetchWorkerTotals(
    ({DateTime start, DateTime end}) range,
    double rate,
  ) async {
    final row = await _database
        .customSelect(
          '''
      SELECT COUNT(*) as count,
        COALESCE(SUM(current_stitches), 0) as total_stitches,
        COALESCE(SUM(current_advances), 0.0) as total_advances,
        COALESCE(SUM(current_deductions), 0.0) as total_deductions,
        COALESCE(SUM(current_earnings), 0.0) as total_earnings,
        COALESCE(SUM(carry_in), 0.0) as total_carry_in
      FROM (SELECT w.id,
        COALESCE((SELECT SUM(stitch_count) FROM worker_production_entries WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0) as current_stitches,
        COALESCE((SELECT SUM(amount) FROM worker_advances WHERE worker_id = w.id AND date BETWEEN ? AND ? AND carried_over = 0), 0.0) as current_advances,
        COALESCE((SELECT SUM(amount) FROM worker_deductions WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0.0) as current_deductions,
        COALESCE((SELECT amount FROM worker_advances WHERE worker_id = w.id AND date = ? AND carried_over = 1 LIMIT 1), 0.0) as carry_in,
        ((COALESCE((SELECT SUM(stitch_count) FROM worker_production_entries WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0) / 100000.0) * ?) as current_earnings
      FROM workers w WHERE w.is_active = 1)
      ''',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withReal(rate),
          ],
        )
        .getSingle();

    final earnings = row.read<double?>('total_earnings') ?? 0.0;
    final deductions = row.read<double?>('total_deductions') ?? 0.0;
    log(
      'DEBUG: Dashboard: Worker Totals -> Earnings: $earnings, Deductions: $deductions',
    );
    return (
      count: row.read<int?>('count') ?? 0,
      earnings: earnings,
      deductions: deductions,
    );
  }

  Future<List<DashboardBarPoint>> fetchTopWorkers(
    ({DateTime start, DateTime end}) range,
  ) async {
    final rows = await _database
        .customSelect(
          '''
      SELECT w.name, COALESCE(SUM(e.stitch_count), 0) as total_stitches
      FROM workers w
      JOIN worker_production_entries e ON w.id = e.worker_id
      WHERE w.is_active = 1 AND e.date BETWEEN ? AND ?
      GROUP BY w.id ORDER BY total_stitches DESC LIMIT 5
      ''',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
          ],
        )
        .get();

    log('DEBUG: Dashboard: Top workers count: ${rows.length}');
    return rows
        .map(
          (row) => DashboardBarPoint(
            label: row.read<String?>('name') ?? '',
            value: (row.read<int?>('total_stitches') ?? 0).toDouble(),
          ),
        )
        .toList();
  }

  Future<int> fetchAbsentDays(DateTime month) async {
    final normalizedMonth = DateTime(month.year, month.month);
    final row = await _database
        .customSelect(
          'SELECT SUM(absent_days) as total FROM worker_absent_days WHERE month_start = ?',
          variables: [Variable.withDateTime(normalizedMonth)],
        )
        .getSingle();
    return row.read<int?>('total') ?? 0;
  }
}
