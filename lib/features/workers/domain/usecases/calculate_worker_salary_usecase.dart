import 'package:injectable/injectable.dart';
import '../entities/worker_month_summary.dart';

@injectable
class CalculateWorkerSalaryUseCase {
  const CalculateWorkerSalaryUseCase();

  WorkerMonthSummary call({
    required DateTime month,
    required int stitchCount,
    required double earnings,
    required double advances,
    required double deductions,
    required double carryOver,
    required int absentDays,
    required double appliedRate,
  }) {
    final netSalary = earnings - advances - carryOver - deductions;

    return WorkerMonthSummary(
      month: month,
      totalStitchCount: stitchCount,
      totalEarnings: earnings,
      totalAdvances: advances,
      totalDeductions: deductions,
      carryOver: carryOver,
      absentDays: absentDays,
      netSalary: netSalary,
      appliedRate: appliedRate,
    );
  }
}
