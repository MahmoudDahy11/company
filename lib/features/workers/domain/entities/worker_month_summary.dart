class WorkerMonthSummary {
  const WorkerMonthSummary({
    required this.month,
    required this.totalStitchCount,
    required this.totalEarnings,
    required this.totalAdvances,
    required this.carryOver,
    required this.absentDays,
    required this.netSalary,
    required this.appliedRate,
  });

  final DateTime month;
  final int totalStitchCount;
  final double totalEarnings;
  final double totalAdvances;
  final double carryOver;
  final int absentDays;
  final double netSalary;
  final double appliedRate;
}
