import 'dart:async';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../helpers/worker_date_utils.dart';
import '../helpers/worker_production_helper.dart';
import '../helpers/worker_sync_helper.dart';

@lazySingleton
class WorkerProductionDataSource {
  const WorkerProductionDataSource(this._database);
  final AppDatabase _database;

  Future<void> addOrUpdateProduction({
    int? productionId, required int workerId, required DateTime date,
    required int stitchCount, String? notes,
  }) async {
    final normalizedDate = dayStart(date);
    await _database.transaction(() async {
      if (productionId == null) {
        await _insertNew(workerId, normalizedDate, stitchCount, notes);
      } else {
        await _updateExisting(
          productionId, workerId, normalizedDate, stitchCount, notes,
        );
      }
    });
  }

  Future<void> _insertNew(int workerId, DateTime date, int stitchCount, String? notes) async {
    final existing = await findProductionForDay(
      _database, workerId: workerId, date: date,
    );
    if (existing == null) {
      final id = await _database.into(_database.workerProductionEntries)
          .insert(WorkerProductionEntriesCompanion.insert(
            workerId: workerId, date: date,
            stitchCount: stitchCount, notes: Value(notes),
          ));
      await _syncAfterWrite(SyncQueueOperation.insert, id);
    } else {
      await (_database.update(_database.workerProductionEntries)
            ..where((table) => table.id.equals(existing.id)))
          .write(WorkerProductionEntriesCompanion(
            date: Value(date),
            stitchCount: Value(existing.stitchCount + stitchCount),
            notes: Value(mergeNotes(existing.notes, notes)),
          ));
      await _syncAfterWrite(SyncQueueOperation.update, existing.id);
    }
  }

  Future<void> _updateExisting(int productionId, int workerId, DateTime date, int stitchCount, String? notes) async {
    final forDay = await findProductionForDay(
      _database, workerId: workerId, date: date, excludingId: productionId,
    );
    if (forDay == null) {
      await (_database.update(_database.workerProductionEntries)
            ..where((table) => table.id.equals(productionId)))
          .write(WorkerProductionEntriesCompanion(
            workerId: Value(workerId), date: Value(date),
            stitchCount: Value(stitchCount), notes: Value(notes),
          ));
      await _syncAfterWrite(SyncQueueOperation.update, productionId);
    } else {
      await (_database.update(_database.workerProductionEntries)
            ..where((table) => table.id.equals(forDay.id)))
          .write(WorkerProductionEntriesCompanion(
            date: Value(date),
            stitchCount: Value(forDay.stitchCount + stitchCount),
            notes: Value(mergeNotes(forDay.notes, notes)),
          ));
      await (_database.delete(_database.workerProductionEntries)
            ..where((table) => table.id.equals(productionId)))
          .go();
      await queueSync(_database,
        operation: SyncQueueOperation.delete,
        tableName: 'worker_production',
        recordId: productionId,
        payload: <String, dynamic>{'id': productionId, 'workerId': workerId},
      );
      await _syncAfterWrite(SyncQueueOperation.update, forDay.id);
    }
  }

  Future<void> deleteProduction(int productionId) async {
    final existing = await (_database.select(_database.workerProductionEntries)
      ..where((table) => table.id.equals(productionId))).getSingleOrNull();
    if (existing == null) return;
    await _database.transaction(() async {
      await (_database.delete(_database.workerProductionEntries)
            ..where((table) => table.id.equals(productionId)))
          .go();
      await queueSync(_database,
        operation: SyncQueueOperation.delete,
        tableName: 'worker_production', recordId: productionId,
        payload: <String, dynamic>{'id': productionId, 'workerId': existing.workerId},
      );
    });
  }

  Future<void> _syncAfterWrite(SyncQueueOperation op, int id) async {
    final row = await (_database.select(_database.workerProductionEntries)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    await queueSync(_database,
      operation: op, tableName: 'worker_production',
      recordId: id, payload: row.toJson(),
    );
  }
}
