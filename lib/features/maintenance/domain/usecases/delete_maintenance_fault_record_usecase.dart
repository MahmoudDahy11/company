import 'package:injectable/injectable.dart';

import '../repositories/maintenance_fault_records_repository.dart';

@injectable
class DeleteMaintenanceFaultRecordUseCase {
  const DeleteMaintenanceFaultRecordUseCase(this._repository);

  final MaintenanceFaultRecordsRepository _repository;

  Future<void> call(int id) {
    return _repository.deleteRecord(id);
  }
}
