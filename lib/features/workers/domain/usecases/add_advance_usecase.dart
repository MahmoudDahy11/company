import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class AddAdvanceUseCase {
  const AddAdvanceUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _repository.addAdvance(
      workerId: workerId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }
}
