import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' hide StaffAdvance;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/staff_advance.dart';
import '../../domain/entities/staff_details_data.dart';
import '../../domain/entities/staff_list_item.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/entities/staff_month_summary.dart';

@lazySingleton
class WomenStaffLocalDataSource {
  WomenStaffLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<StaffListItem>> watchStaff(DateTime month) {
    return _watchTrigger().asyncMap((_) => _buildStaffList(month));
  }

  Stream<StaffDetailsData> watchStaffDetails(int staffId, DateTime month) {
    return _watchTrigger().asyncMap((_) => _buildStaffDetails(staffId, month));
  }

  Future<void> addStaff({
    required String name,
    required double monthlySalary,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.womenStaffMembers)
          .insert(
            WomenStaffMembersCompanion.insert(
              name: name.trim(),
              monthlySalary: monthlySalary,
            ),
          );

      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'women_staff',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'name': name.trim(),
          'monthlySalary': monthlySalary,
          'createdAt': DateTime.now().toIso8601String(),
          'isActive': true,
        },
      );
    });
  }

  Future<void> deleteStaff(int staffId) async {
    final existing = await (_database.select(
      _database.womenStaffMembers,
    )..where((table) => table.id.equals(staffId))).getSingleOrNull();
    if (existing == null) {
      return;
    }

    await _database.transaction(() async {
      await (_database.update(_database.womenStaffMembers)
            ..where((table) => table.id.equals(staffId)))
          .write(const WomenStaffMembersCompanion(isActive: Value(false)));

      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'women_staff',
        recordId: staffId,
        payload: <String, dynamic>{
          'id': existing.id,
          'name': existing.name,
          'monthlySalary': existing.monthlySalary,
          'createdAt': existing.createdAt.toIso8601String(),
          'isActive': false,
        },
      );
    });
  }

  Future<void> updateSalary({
    required int staffId,
    required double monthlySalary,
  }) async {
    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.womenStaffMembers,
      )..where((table) => table.id.equals(staffId))).getSingle();

      await (_database.update(
        _database.womenStaffMembers,
      )..where((table) => table.id.equals(staffId))).write(
        WomenStaffMembersCompanion(monthlySalary: Value(monthlySalary)),
      );

      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'women_staff',
        recordId: staffId,
        payload: <String, dynamic>{
          'id': existing.id,
          'name': existing.name,
          'monthlySalary': monthlySalary,
          'createdAt': existing.createdAt.toIso8601String(),
          'isActive': existing.isActive,
        },
      );
    });
  }

  Future<void> addAdvance({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.staffAdvances)
          .insert(
            StaffAdvancesCompanion.insert(
              staffId: staffId,
              amount: amount,
              date: date,
              notes: Value(notes),
            ),
          );

      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'staff_advances',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'staffId': staffId,
          'amount': amount,
          'date': date.toIso8601String(),
          'notes': notes,
          'carriedOver': false,
        },
      );
    });
  }

  Future<void> deleteAdvance(int advanceId) async {
    final existing = await (_database.select(
      _database.staffAdvances,
    )..where((table) => table.id.equals(advanceId))).getSingleOrNull();
    if (existing == null) {
      return;
    }

    await _database.transaction(() async {
      await (_database.delete(
        _database.staffAdvances,
      )..where((table) => table.id.equals(advanceId))).go();

      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'staff_advances',
        recordId: advanceId,
        payload: <String, dynamic>{
          'id': advanceId,
          'staffId': existing.staffId,
        },
      );
    });
  }

  Stream<List<QueryRow>> _watchTrigger() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {_database.womenStaffMembers, _database.staffAdvances},
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
      final summary = await _buildSummary(row.id, month);
      result.add(
        StaffListItem(
          id: row.id,
          name: row.name,
          monthlySalary: summary.monthlySalary,
          totalAdvances: summary.totalAdvances,
          netSalary: summary.netSalary,
        ),
      );
    }
    return result;
  }

  Future<StaffDetailsData> _buildStaffDetails(
    int staffId,
    DateTime month,
  ) async {
    final member = await (_database.select(
      _database.womenStaffMembers,
    )..where((table) => table.id.equals(staffId))).getSingle();
    final summary = await _buildSummary(staffId, month);
    final monthRange = _monthRange(month);

    final advancesRows =
        await (_database.select(_database.staffAdvances)
              ..where(
                (table) =>
                    table.staffId.equals(staffId) &
                    table.date.isBetweenValues(
                      monthRange.start,
                      monthRange.end,
                    ),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.date)]))
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
    );
  }

  Future<StaffMonthSummary> _buildSummary(int staffId, DateTime month) async {
    final normalizedMonth = _monthStart(month);
    final member = await (_database.select(
      _database.womenStaffMembers,
    )..where((table) => table.id.equals(staffId))).getSingle();
    final advancesRows = await (_database.select(
      _database.staffAdvances,
    )..where((table) => table.staffId.equals(staffId))).get();

    final monthlyAdvances = <DateTime, double>{};
    final firstMonth = _monthStart(member.createdAt);

    for (final advance in advancesRows) {
      final key = _monthStart(advance.date);
      monthlyAdvances[key] = (monthlyAdvances[key] ?? 0) + advance.amount;
    }

    double carryIn = 0;
    DateTime cursor = firstMonth;
    while (!_isAfterMonth(cursor, normalizedMonth)) {
      final advances = monthlyAdvances[cursor] ?? 0;
      final net = member.monthlySalary - advances - carryIn;
      final nextCarry = net < 0 ? -net : 0;

      if (_sameMonth(cursor, normalizedMonth)) {
        return StaffMonthSummary(
          month: normalizedMonth,
          monthlySalary: member.monthlySalary,
          totalAdvances: advances,
          carryOver: carryIn,
          netSalary: net,
        );
      }

      carryIn = nextCarry.toDouble();
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    return StaffMonthSummary(
      month: normalizedMonth,
      monthlySalary: member.monthlySalary,
      totalAdvances: 0,
      carryOver: carryIn,
      netSalary: member.monthlySalary - carryIn,
    );
  }

  Future<void> _queueSync({
    required SyncQueueOperation operation,
    required String tableName,
    required int recordId,
    required Map<String, dynamic> payload,
  }) async {
    await _database
        .into(_database.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            operation: operation,
            targetTableName: tableName,
            recordId: recordId,
            payload: jsonEncode(payload),
          ),
        );
  }

  DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);

  ({DateTime start, DateTime end}) _monthRange(DateTime date) {
    final start = _monthStart(date);
    final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
    return (start: start, end: end);
  }

  bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  bool _isAfterMonth(DateTime value, DateTime target) {
    return value.year > target.year ||
        (value.year == target.year && value.month > target.month);
  }
}
