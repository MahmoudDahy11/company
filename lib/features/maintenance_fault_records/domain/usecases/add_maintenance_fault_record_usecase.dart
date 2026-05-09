import 'package:injectable/injectable.dart';

import '../repositories/maintenance_fault_records_repository.dart';

@injectable
class AddMaintenanceFaultRecordUseCase {
  const AddMaintenanceFaultRecordUseCase(this._repository);

  final MaintenanceFaultRecordsRepository _repository;

  Future<void> call({
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) {
    return _repository.addRecord(
      machineName: machineName,
      faultName: faultName,
      cost: cost,
      totalCost: totalCost,
    );
  }
}
