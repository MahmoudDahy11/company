class StaffMember {
  const StaffMember({
    required this.id,
    required this.name,
    required this.monthlySalary,
    required this.createdAt,
    required this.isActive,
  });

  final int id;
  final String name;
  final double monthlySalary;
  final DateTime createdAt;
  final bool isActive;
}
