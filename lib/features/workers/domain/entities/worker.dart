class Worker {
  const Worker({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.isActive,
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final bool isActive;
}
