import 'package:injectable/injectable.dart';

@injectable
class CalculateWomenStaffSalaryUseCase {
  const CalculateWomenStaffSalaryUseCase();

  double call({
    required double monthlySalary,
    required double advances,
    required double carryOver,
  }) {
    return monthlySalary - advances - carryOver;
  }
}
