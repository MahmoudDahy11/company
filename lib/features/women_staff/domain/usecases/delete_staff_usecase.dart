import 'package:injectable/injectable.dart';

import '../repositories/women_staff_repository.dart';

@injectable
class DeleteStaffUseCase {
  const DeleteStaffUseCase(this._repository);

  final WomenStaffRepository _repository;

  Future<void> call(int staffId) {
    return _repository.deleteStaff(staffId);
  }
}
