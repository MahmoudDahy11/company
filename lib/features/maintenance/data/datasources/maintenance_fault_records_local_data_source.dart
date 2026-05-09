import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide MaintenanceFaultRecord;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/maintenance_fault_record.dart';
import 'sync_queue_helper.dart';

@lazySingleton
class MaintenanceFaultRecordsLocalDataSource {
  MaintenanceFaultRecordsLocalDataSource(this._database)
    : _syncQueue = SyncQueueHelper(_database);

  final AppDatabase _database;
  final SyncQueueHelper _syncQueue;

  Stream<List<MaintenanceFaultRecord>> watchRecords() {
    return _watchTrigger().asyncMap((_) => _getAllRecords());
  }

  Future<void> addRecord({
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.maintenanceFaultRecords)
          .insert(
            MaintenanceFaultRecordsCompanion.insert(
              machineName: machineName.trim(),
              faultName: faultName.trim(),
              cost: cost,
              totalCost: totalCost,
            ),
          );

      final row = await (_database.select(
        _database.maintenanceFaultRecords,
      )..where((t) => t.id.equals(id))).getSingle();

      await _syncQueue.queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'maintenance_fault_records',
        recordId: id,
        payload: row.toJson(),
      );
    });
  }

  Future<void> updateRecord({
    required int id,
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) async {
    await _database.transaction(() async {
      await (_database.update(
        _database.maintenanceFaultRecords,
      )..where((t) => t.id.equals(id))).write(
        MaintenanceFaultRecordsCompanion(
          machineName: Value(machineName.trim()),
          faultName: Value(faultName.trim()),
          cost: Value(cost),
          totalCost: Value(totalCost),
        ),
      );

      final row = await (_database.select(
        _database.maintenanceFaultRecords,
      )..where((t) => t.id.equals(id))).getSingle();

      await _syncQueue.queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'maintenance_fault_records',
        recordId: id,
        payload: row.toJson(),
      );
    });
  }

  Future<void> deleteRecord(int id) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.maintenanceFaultRecords,
      )..where((t) => t.id.equals(id))).go();

      await _syncQueue.queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'maintenance_fault_records',
        recordId: id,
        payload: {},
      );
    });
  }

  Future<List<MaintenanceFaultRecord>> _getAllRecords() async {
    final rows = await (_database.select(
      _database.maintenanceFaultRecords,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    return rows
        .map(
          (r) => MaintenanceFaultRecord(
            id: r.id,
            machineName: r.machineName,
            faultName: r.faultName,
            cost: r.cost,
            totalCost: r.totalCost,
            createdAt: r.createdAt,
          ),
        )
        .toList();
  }

  Stream<List<QueryRow>> _watchTrigger() => _database
      .customSelect('SELECT 1', readsFrom: {_database.maintenanceFaultRecords})
      .watch();
}
