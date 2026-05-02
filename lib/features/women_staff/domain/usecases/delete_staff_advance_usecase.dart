import 'package:injectable/injectable.dart';

import '../repositories/women_staff_repository.dart';

@injectable
class DeleteStaffAdvanceUseCase {
  const DeleteStaffAdvanceUseCase(this._repository);

  final WomenStaffRepository _repository;

  Future<void> call(int advanceId) {
    return _repository.deleteAdvance(advanceId);
  }
}
