class WorkerListItem {
  const WorkerListItem({
    required this.id,
    required this.name,
    required this.totalEarnings,
    required this.totalAdvances,
    required this.netSalary,
  });

  final int id;
  final String name;
  final double totalEarnings;
  final double totalAdvances;
  final double netSalary;
}
