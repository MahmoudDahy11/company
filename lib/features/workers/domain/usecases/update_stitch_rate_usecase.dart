import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class UpdateStitchRateUseCase {
  const UpdateStitchRateUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call({required double rate, required DateTime effectiveFrom}) {
    return _repository.updateStitchRate(
      rate: rate,
      effectiveFrom: effectiveFrom,
    );
  }
}
