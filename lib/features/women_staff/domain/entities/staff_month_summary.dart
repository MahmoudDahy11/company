class StaffMonthSummary {
  const StaffMonthSummary({
    required this.month,
    required this.monthlySalary,
    required this.totalAdvances,
    required this.carryOver,
    required this.netSalary,
  });

  final DateTime month;
  final double monthlySalary;
  final double totalAdvances;
  final double carryOver;
  final double netSalary;
}
