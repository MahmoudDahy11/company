import 'dart:developer';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_summary.dart';

class DashboardStaffQueries {
  const DashboardStaffQueries(this._database);

  final AppDatabase _database;

  Future<({double salaries, double advances, double carryIn})>
  fetchWomenStaffTotals(({DateTime start, DateTime end}) range) async {
    final row = await _database
        .customSelect(
          '''
      SELECT COALESCE(SUM(monthly_salary), 0.0) as total_salaries,
        COALESCE(SUM(current_advances), 0.0) as total_advances,
        COALESCE(SUM(carry_in), 0.0) as total_carry_in
      FROM (SELECT m.monthly_salary,
        COALESCE((SELECT SUM(amount) FROM staff_advances WHERE staff_id = m.id AND date BETWEEN ? AND ?), 0.0) as current_advances,
        COALESCE((SELECT amount FROM staff_advances WHERE staff_id = m.id AND date = ? AND carried_over = 1 LIMIT 1), 0.0) as carry_in
      FROM women_staff_members m WHERE m.is_active = 1)
      ''',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.start),
          ],
        )
        .getSingle();

    final salaries = row.read<double?>('total_salaries') ?? 0.0;
    final advances = row.read<double?>('total_advances') ?? 0.0;
    final carryIn = row.read<double?>('total_carry_in') ?? 0.0;
    log(
      'DEBUG: Dashboard: Staff Totals -> Salaries: $salaries, Advances: $advances, CarryIn: $carryIn',
    );
    return (salaries: salaries, advances: advances, carryIn: carryIn);
  }

  Future<List<DashboardBarPoint>> fetchWomenAdvances(
    ({DateTime start, DateTime end}) range,
  ) async {
    final rows = await _database
        .customSelect(
          '''
      SELECT m.name, COALESCE(SUM(a.amount), 0.0) as total_advances
      FROM women_staff_members m
      JOIN staff_advances a ON m.id = a.staff_id
      WHERE m.is_active = 1 AND a.date BETWEEN ? AND ?
      GROUP BY m.id
      ''',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
          ],
        )
        .get();

    return rows
        .map(
          (row) => DashboardBarPoint(
            label: row.read<String?>('name') ?? '',
            value: row.read<double?>('total_advances') ?? 0.0,
          ),
        )
        .toList();
  }
}
