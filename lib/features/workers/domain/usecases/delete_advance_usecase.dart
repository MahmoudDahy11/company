import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class DeleteAdvanceUseCase {
  const DeleteAdvanceUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call(int advanceId) {
    return _repository.deleteAdvance(advanceId);
  }
}
