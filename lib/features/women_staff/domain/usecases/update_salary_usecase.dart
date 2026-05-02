import 'package:injectable/injectable.dart';

import '../repositories/women_staff_repository.dart';

@injectable
class UpdateSalaryUseCase {
  const UpdateSalaryUseCase(this._repository);

  final WomenStaffRepository _repository;

  Future<void> call({required int staffId, required double monthlySalary}) {
    return _repository.updateSalary(
      staffId: staffId,
      monthlySalary: monthlySalary,
    );
  }
}
