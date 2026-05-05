class StaffListItem {
  const StaffListItem({
    required this.id,
    required this.name,
    required this.monthlySalary,
    required this.totalAdvances,
    required this.totalDeductions,
    required this.carryOver,
    required this.netSalary,
  });

  final int id;
  final String name;
  final double monthlySalary;
  final double totalAdvances;
  final double totalDeductions;
  final double carryOver;
  final double netSalary;
}
