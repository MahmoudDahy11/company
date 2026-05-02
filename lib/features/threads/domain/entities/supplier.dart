class Supplier {
  const Supplier({
    required this.id,
    required this.name,
    this.phone,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String? phone;
  final DateTime createdAt;
}
