import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class DeleteWorkerDeductionUseCase {
  const DeleteWorkerDeductionUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call(int deductionId) {
    return _repository.deleteDeduction(deductionId);
  }
}
