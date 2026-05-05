import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class AddOrUpdateAdvanceUseCase {
  const AddOrUpdateAdvanceUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call({
    int? advanceId,
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _repository.addOrUpdateAdvance(
      advanceId: advanceId,
      workerId: workerId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }
}
