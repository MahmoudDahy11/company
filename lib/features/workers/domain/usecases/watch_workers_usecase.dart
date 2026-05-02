import 'package:injectable/injectable.dart';

import '../entities/worker_list_item.dart';
import '../repositories/workers_repository.dart';

@injectable
class WatchWorkersUseCase {
  const WatchWorkersUseCase(this._repository);

  final WorkersRepository _repository;

  Stream<List<WorkerListItem>> call(DateTime month) {
    return _repository.watchWorkers(month);
  }
}
