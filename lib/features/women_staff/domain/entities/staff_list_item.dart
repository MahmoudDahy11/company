class StaffListItem {
  const StaffListItem({
    required this.id,
    required this.name,
    required this.monthlySalary,
    required this.totalAdvances,
    required this.netSalary,
  });

  final int id;
  final String name;
  final double monthlySalary;
  final double totalAdvances;
  final double netSalary;
}
