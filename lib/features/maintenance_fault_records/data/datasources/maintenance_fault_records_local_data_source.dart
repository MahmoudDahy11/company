import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide MaintenanceFaultRecord;
import '../../domain/entities/maintenance_fault_record.dart';

@lazySingleton
class MaintenanceFaultRecordsLocalDataSource {
  const MaintenanceFaultRecordsLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<MaintenanceFaultRecord>> watchRecords() {
    return _watchTrigger().asyncMap((_) => _getAllRecords());
  }

  Future<void> addRecord({
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) async {
    await _database.into(_database.maintenanceFaultRecords).insert(
          MaintenanceFaultRecordsCompanion.insert(
            machineName: machineName.trim(),
            faultName: faultName.trim(),
            cost: cost,
            totalCost: totalCost,
          ),
        );
  }

  Future<void> updateRecord({
    required int id,
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) async {
    await (_database.update(_database.maintenanceFaultRecords)
          ..where((t) => t.id.equals(id)))
        .write(
          MaintenanceFaultRecordsCompanion(
            machineName: Value(machineName.trim()),
            faultName: Value(faultName.trim()),
            cost: Value(cost),
            totalCost: Value(totalCost),
          ),
        );
  }

  Future<void> deleteRecord(int id) async {
    await (_database.delete(_database.maintenanceFaultRecords)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<List<MaintenanceFaultRecord>> _getAllRecords() async {
    final rows = await (_database.select(_database.maintenanceFaultRecords)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows
        .map(
          (row) => MaintenanceFaultRecord(
            id: row.id,
            machineName: row.machineName,
            faultName: row.faultName,
            cost: row.cost,
            totalCost: row.totalCost,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  Stream<List<QueryRow>> _watchTrigger() {
    return _database.customSelect(
      'SELECT 1',
      readsFrom: {_database.maintenanceFaultRecords},
    ).watch();
  }
}
