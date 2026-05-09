class WorkerListItem {
  const WorkerListItem({
    required this.id,
    required this.name,
    required this.totalEarnings,
    required this.totalAdvances,
    required this.totalDeductions,
    required this.absentDays,
    required this.netSalary,
  });

  final int id;
  final String name;
  final double totalEarnings;
  final double totalAdvances;
  final double totalDeductions;
  final int absentDays;
  final double netSalary;
}
