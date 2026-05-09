import '../entities/maintenance_fault_record.dart';

abstract class MaintenanceFaultRecordsRepository {
  Stream<List<MaintenanceFaultRecord>> watchRecords();

  Future<void> addRecord({
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  });

  Future<void> updateRecord({
    required int id,
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  });

  Future<void> deleteRecord(int id);
}
