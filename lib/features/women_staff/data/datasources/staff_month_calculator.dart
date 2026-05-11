import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/staff_month_summary.dart';

@injectable
class StaffMonthCalculator {
  StaffMonthCalculator(this._database);

  final AppDatabase _database;

  Future<StaffMonthSummary> calculate(int staffId, DateTime month) async {
    final normalizedMonth = DateTime(month.year, month.month);
    final member = await (_database.select(
      _database.womenStaffMembers,
    )..where((table) => table.id.equals(staffId))).getSingle();
    final advancesRows = await (_database.select(
      _database.staffAdvances,
    )..where((table) => table.staffId.equals(staffId))).get();
    final deductionsRows = await (_database.select(
      _database.staffDeductions,
    )..where((table) => table.staffId.equals(staffId))).get();

    final monthlyAdvances = <DateTime, double>{};
    final monthlyDeductions = <DateTime, double>{};
    final firstMonth = DateTime(member.createdAt.year, member.createdAt.month);

    for (final a in advancesRows) {
      final key = DateTime(a.date.year, a.date.month);
      monthlyAdvances[key] = (monthlyAdvances[key] ?? 0) + a.amount;
    }
    for (final d in deductionsRows) {
      final key = DateTime(d.date.year, d.date.month);
      monthlyDeductions[key] = (monthlyDeductions[key] ?? 0) + d.amount;
    }

    double carryIn = 0;
    var cursor = firstMonth;
    while (!(cursor.year > normalizedMonth.year ||
        (cursor.year == normalizedMonth.year &&
            cursor.month > normalizedMonth.month))) {
      final advances = monthlyAdvances[cursor] ?? 0;
      final deductions = monthlyDeductions[cursor] ?? 0;
      final net = member.monthlySalary - advances - deductions - carryIn;

      if (cursor.year == normalizedMonth.year &&
          cursor.month == normalizedMonth.month) {
        return StaffMonthSummary(
          month: normalizedMonth,
          monthlySalary: member.monthlySalary,
          totalAdvances: advances,
          totalDeductions: deductions,
          carryOver: carryIn,
          netSalary: net,
        );
      }

      carryIn = (net < 0 ? -net : 0).toDouble();
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    return StaffMonthSummary(
      month: normalizedMonth,
      monthlySalary: member.monthlySalary,
      totalAdvances: 0,
      totalDeductions: 0,
      carryOver: carryIn,
      netSalary: member.monthlySalary - carryIn,
    );
  }
}
