import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class AddWorkerUseCase {
  const AddWorkerUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call(String name) {
    return _repository.addWorker(name);
  }
}
