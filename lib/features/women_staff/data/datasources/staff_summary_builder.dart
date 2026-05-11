import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/staff_details_data.dart';
import '../../domain/entities/staff_list_item.dart';
import 'staff_details_assembler.dart';
import 'staff_month_calculator.dart';

@injectable
class StaffSummaryBuilder {
  StaffSummaryBuilder(this._database, this._calculator, this._assembler);

  final AppDatabase _database;
  final StaffMonthCalculator _calculator;
  final StaffDetailsAssembler _assembler;

  Stream<List<StaffListItem>> watchStaff(DateTime month) {
    return _watchTrigger().asyncMap((_) => _buildStaffList(month));
  }

  Stream<StaffDetailsData> watchStaffDetails(int staffId, DateTime month) {
    return _watchTrigger().asyncMap((_) => _assembler.assemble(staffId, month));
  }

  Stream<List<QueryRow>> _watchTrigger() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.womenStaffMembers,
            _database.staffAdvances,
            _database.staffDeductions,
          },
        )
        .watch();
  }

  Future<List<StaffListItem>> _buildStaffList(DateTime month) async {
    final rows =
        await (_database.select(_database.womenStaffMembers)
              ..where((table) => table.isActive.equals(true))
              ..orderBy([(table) => OrderingTerm(expression: table.name)]))
            .get();

    final result = <StaffListItem>[];
    for (final row in rows) {
      final summary = await _calculator.calculate(row.id, month);
      result.add(
        StaffListItem(
          id: row.id,
          name: row.name,
          monthlySalary: summary.monthlySalary,
          totalAdvances: summary.totalAdvances,
          totalDeductions: summary.totalDeductions,
          carryOver: summary.carryOver,
          netSalary: summary.netSalary,
        ),
      );
    }
    return result;
  }
}
