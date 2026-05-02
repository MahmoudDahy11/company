import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class DeleteWorkerUseCase {
  const DeleteWorkerUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call(int workerId) {
    return _repository.deleteWorker(workerId);
  }
}
