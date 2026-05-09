import 'package:injectable/injectable.dart';

import '../repositories/maintenance_fault_records_repository.dart';

@injectable
class UpdateMaintenanceFaultRecordUseCase {
  const UpdateMaintenanceFaultRecordUseCase(this._repository);

  final MaintenanceFaultRecordsRepository _repository;

  Future<void> call({
    required int id,
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) {
    return _repository.updateRecord(
      id: id,
      machineName: machineName,
      faultName: faultName,
      cost: cost,
      totalCost: totalCost,
    );
  }
}
