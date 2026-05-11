import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide StaffAdvance, StaffDeduction;
import '../../domain/entities/staff_advance.dart';
import '../../domain/entities/staff_deduction.dart';
import '../../domain/entities/staff_details_data.dart';
import '../../domain/entities/staff_member.dart';
import 'staff_month_calculator.dart';

@injectable
class StaffDetailsAssembler {
  StaffDetailsAssembler(this._database, this._calculator);

  final AppDatabase _database;
  final StaffMonthCalculator _calculator;

  Future<StaffDetailsData> assemble(int staffId, DateTime month) async {
    final member = await (_database.select(
      _database.womenStaffMembers,
    )..where((table) => table.id.equals(staffId))).getSingle();
    final summary = await _calculator.calculate(staffId, month);
    final range = _monthRange(month);

    final advancesRows =
        await (_database.select(_database.staffAdvances)
              ..where(
                (table) =>
                    table.staffId.equals(staffId) &
                    table.date.isBetweenValues(range.start, range.end),
              )
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.date, mode: OrderingMode.desc),
              ]))
            .get();

    final advances = <StaffAdvance>[
      if (summary.carryOver > 0)
        StaffAdvance(
          id: -summary.month.millisecondsSinceEpoch,
          staffId: staffId,
          amount: summary.carryOver,
          date: summary.month,
          notes: 'carry-over',
          carriedOver: true,
        ),
      ...advancesRows.map(
        (row) => StaffAdvance(
          id: row.id,
          staffId: row.staffId,
          amount: row.amount,
          date: row.date,
          notes: row.notes,
          carriedOver: row.carriedOver,
        ),
      ),
    ];

    final deductionsRows =
        await (_database.select(_database.staffDeductions)
              ..where(
                (table) =>
                    table.staffId.equals(staffId) &
                    table.date.isBetweenValues(range.start, range.end),
              )
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.date, mode: OrderingMode.desc),
              ]))
            .get();

    final deductions = deductionsRows
        .map(
          (row) => StaffDeduction(
            id: row.id,
            staffId: row.staffId,
            amount: row.amount,
            date: row.date,
            notes: row.notes,
          ),
        )
        .toList();

    return StaffDetailsData(
      staffMember: StaffMember(
        id: member.id,
        name: member.name,
        monthlySalary: member.monthlySalary,
        createdAt: member.createdAt,
        isActive: member.isActive,
      ),
      summary: summary,
      advances: advances,
      deductions: deductions,
    );
  }

  ({DateTime start, DateTime end}) _monthRange(DateTime date) {
    final start = DateTime(date.year, date.month);
    final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
    return (start: start, end: end);
  }
}
