import 'package:injectable/injectable.dart';

import '../../domain/entities/maintenance_fault_record.dart';
import '../../domain/repositories/maintenance_fault_records_repository.dart';
import '../datasources/maintenance_fault_records_local_data_source.dart';

@LazySingleton(as: MaintenanceFaultRecordsRepository)
class MaintenanceFaultRecordsRepositoryImpl
    implements MaintenanceFaultRecordsRepository {
  MaintenanceFaultRecordsRepositoryImpl(this._localDataSource);

  final MaintenanceFaultRecordsLocalDataSource _localDataSource;

  @override
  Stream<List<MaintenanceFaultRecord>> watchRecords() {
    return _localDataSource.watchRecords();
  }

  @override
  Future<void> addRecord({
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) {
    return _localDataSource.addRecord(
      machineName: machineName,
      faultName: faultName,
      cost: cost,
      totalCost: totalCost,
    );
  }

  @override
  Future<void> updateRecord({
    required int id,
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) {
    return _localDataSource.updateRecord(
      id: id,
      machineName: machineName,
      faultName: faultName,
      cost: cost,
      totalCost: totalCost,
    );
  }

  @override
  Future<void> deleteRecord(int id) {
    return _localDataSource.deleteRecord(id);
  }
}
