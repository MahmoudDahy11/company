import 'package:injectable/injectable.dart';

import '../repositories/women_staff_repository.dart';

@injectable
class AddStaffAdvanceUseCase {
  const AddStaffAdvanceUseCase(this._repository);

  final WomenStaffRepository _repository;

  Future<void> call({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _repository.addAdvance(
      staffId: staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }
}
