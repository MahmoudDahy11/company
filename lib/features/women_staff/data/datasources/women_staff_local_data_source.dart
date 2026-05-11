import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide StaffAdvance, StaffDeduction;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/staff_details_data.dart';
import '../../domain/entities/staff_list_item.dart';
import 'staff_summary_builder.dart';
import 'sync_queue_helper.dart';

@lazySingleton
class WomenStaffLocalDataSource {
  WomenStaffLocalDataSource(this._database, this._summaryBuilder);

  final AppDatabase _database;
  final StaffSummaryBuilder _summaryBuilder;

  Stream<List<StaffListItem>> watchStaff(DateTime month) {
    return _summaryBuilder.watchStaff(month);
  }

  Stream<StaffDetailsData> watchStaffDetails(int staffId, DateTime month) {
    return _summaryBuilder.watchStaffDetails(staffId, month);
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
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.insert,
        tableName: 'women_staff',
        recordId: id,
        payload: {
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
    if (existing == null) return;
    await _database.transaction(() async {
      await (_database.update(_database.womenStaffMembers)
            ..where((table) => table.id.equals(staffId)))
          .write(const WomenStaffMembersCompanion(isActive: Value(false)));
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.update,
        tableName: 'women_staff',
        recordId: staffId,
        payload: {
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
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.update,
        tableName: 'women_staff',
        recordId: staffId,
        payload: {
          'id': existing.id,
          'name': existing.name,
          'monthlySalary': monthlySalary,
          'createdAt': existing.createdAt.toIso8601String(),
          'isActive': existing.isActive,
        },
      );
    });
  }
}
