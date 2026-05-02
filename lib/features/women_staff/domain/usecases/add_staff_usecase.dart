import 'package:injectable/injectable.dart';

import '../repositories/women_staff_repository.dart';

@injectable
class AddStaffUseCase {
  const AddStaffUseCase(this._repository);

  final WomenStaffRepository _repository;

  Future<void> call({required String name, required double monthlySalary}) {
    return _repository.addStaff(name: name, monthlySalary: monthlySalary);
  }
}
