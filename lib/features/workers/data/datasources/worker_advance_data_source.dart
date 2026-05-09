import 'dart:async';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../helpers/worker_date_utils.dart';
import '../helpers/worker_sync_helper.dart';

@lazySingleton
class WorkerAdvanceDataSource {
  const WorkerAdvanceDataSource(this._database);
  final AppDatabase _database;

  Future<void> addAdvance({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.workerAdvances)
          .insert(
            WorkerAdvancesCompanion.insert(
              workerId: workerId,
              amount: amount,
              date: date,
              notes: Value(notes),
            ),
          );
      final row = await (_database.select(
        _database.workerAdvances,
      )..where((t) => t.id.equals(id))).getSingle();
      await queueSync(
        _database,
        operation: SyncQueueOperation.insert,
        tableName: 'worker_advances',
        recordId: id,
        payload: row.toJson(),
      );
    });
  }

  Future<void> addOrUpdateAdvance({
    int? advanceId,
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      late final int id;
      late final SyncQueueOperation op;
      if (advanceId == null) {
        id = await _database
            .into(_database.workerAdvances)
            .insert(
              WorkerAdvancesCompanion.insert(
                workerId: workerId,
                amount: amount,
                date: date,
                notes: Value(notes),
              ),
            );
        op = SyncQueueOperation.insert;
      } else {
        await (_database.update(
          _database.workerAdvances,
        )..where((table) => table.id.equals(advanceId))).write(
          WorkerAdvancesCompanion(
            workerId: Value(workerId),
            amount: Value(amount),
            date: Value(date),
            notes: Value(notes),
          ),
        );
        id = advanceId;
        op = SyncQueueOperation.update;
      }
      final row = await (_database.select(
        _database.workerAdvances,
      )..where((t) => t.id.equals(id))).getSingle();
      await queueSync(
        _database,
        operation: op,
        tableName: 'worker_advances',
        recordId: id,
        payload: row.toJson(),
      );
    });
  }

  Future<void> deleteAdvance(int advanceId) async {
    final existing = await (_database.select(
      _database.workerAdvances,
    )..where((table) => table.id.equals(advanceId))).getSingleOrNull();
    if (existing == null) return;
    await _database.transaction(() async {
      await (_database.delete(
        _database.workerAdvances,
      )..where((table) => table.id.equals(advanceId))).go();
      await queueSync(
        _database,
        operation: SyncQueueOperation.delete,
        tableName: 'worker_advances',
        recordId: advanceId,
        payload: <String, dynamic>{
          'id': advanceId,
          'workerId': existing.workerId,
        },
      );
    });
  }

  Future<void> upsertAbsentDays({
    required int workerId,
    required DateTime month,
    required int absentDays,
  }) async {
    final normalizedMonth = monthStart(month);
    await _database.transaction(() async {
      final existing =
          await (_database.select(_database.workerAbsentDays)..where(
                (table) =>
                    table.workerId.equals(workerId) &
                    table.monthStart.equals(normalizedMonth),
              ))
              .getSingleOrNull();
      late final int id;
      late final SyncQueueOperation op;
      if (existing == null) {
        id = await _database
            .into(_database.workerAbsentDays)
            .insert(
              WorkerAbsentDaysCompanion.insert(
                workerId: workerId,
                monthStart: normalizedMonth,
                absentDays: Value(absentDays),
              ),
            );
        op = SyncQueueOperation.insert;
      } else {
        await (_database.update(_database.workerAbsentDays)
              ..where((table) => table.id.equals(existing.id)))
            .write(WorkerAbsentDaysCompanion(absentDays: Value(absentDays)));
        id = existing.id;
        op = SyncQueueOperation.update;
      }
      final row = await (_database.select(
        _database.workerAbsentDays,
      )..where((t) => t.id.equals(id))).getSingle();
      await queueSync(
        _database,
        operation: op,
        tableName: 'worker_absent_days',
        recordId: id,
        payload: row.toJson(),
      );
    });
  }
}
