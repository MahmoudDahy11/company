import 'package:injectable/injectable.dart';

import '../entities/worker_details_data.dart';
import '../repositories/workers_repository.dart';

@injectable
class WatchWorkerDetailsUseCase {
  const WatchWorkerDetailsUseCase(this._repository);

  final WorkersRepository _repository;

  Stream<WorkerDetailsData> call(int workerId, DateTime month) {
    return _repository.watchWorkerDetails(workerId, month);
  }
}
