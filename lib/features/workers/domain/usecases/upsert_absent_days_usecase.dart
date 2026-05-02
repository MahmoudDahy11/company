import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class UpsertAbsentDaysUseCase {
  const UpsertAbsentDaysUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call({
    required int workerId,
    required DateTime month,
    required int absentDays,
  }) {
    return _repository.upsertAbsentDays(
      workerId: workerId,
      month: month,
      absentDays: absentDays,
    );
  }
}
