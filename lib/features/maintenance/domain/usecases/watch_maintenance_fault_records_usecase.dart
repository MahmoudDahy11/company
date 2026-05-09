import 'package:injectable/injectable.dart';

import '../entities/maintenance_fault_record.dart';
import '../repositories/maintenance_fault_records_repository.dart';

@injectable
class WatchMaintenanceFaultRecordsUseCase {
  const WatchMaintenanceFaultRecordsUseCase(this._repository);

  final MaintenanceFaultRecordsRepository _repository;

  Stream<List<MaintenanceFaultRecord>> call() {
    return _repository.watchRecords();
  }
}
