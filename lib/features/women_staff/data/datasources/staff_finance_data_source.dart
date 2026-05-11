import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_queue_table.dart';
import 'sync_queue_helper.dart';

@injectable
class StaffFinanceDataSource {
  StaffFinanceDataSource(this._database);

  final AppDatabase _database;

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
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.insert,
        tableName: 'staff_advances',
        recordId: id,
        payload: {
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
    if (existing == null) return;
    await _database.transaction(() async {
      await (_database.delete(
        _database.staffAdvances,
      )..where((table) => table.id.equals(advanceId))).go();
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.delete,
        tableName: 'staff_advances',
        recordId: advanceId,
        payload: {'id': advanceId, 'staffId': existing.staffId},
      );
    });
  }

  Future<void> addDeduction({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.staffDeductions)
          .insert(
            StaffDeductionsCompanion.insert(
              staffId: staffId,
              amount: amount,
              date: date,
              notes: Value(notes),
            ),
          );
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.insert,
        tableName: 'staff_deductions',
        recordId: id,
        payload: {
          'id': id,
          'staffId': staffId,
          'amount': amount,
          'date': date.toIso8601String(),
          'notes': notes,
        },
      );
    });
  }

  Future<void> deleteDeduction(int deductionId) async {
    final existing = await (_database.select(
      _database.staffDeductions,
    )..where((table) => table.id.equals(deductionId))).getSingleOrNull();
    if (existing == null) return;
    await _database.transaction(() async {
      await (_database.delete(
        _database.staffDeductions,
      )..where((table) => table.id.equals(deductionId))).go();
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.delete,
        tableName: 'staff_deductions',
        recordId: deductionId,
        payload: {'id': deductionId, 'staffId': existing.staffId},
      );
    });
  }
}
