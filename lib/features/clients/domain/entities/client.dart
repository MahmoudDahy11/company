class Client {
  const Client({
    required this.id,
    required this.name,
    this.phone,
    required this.createdAt,
    required this.isActive,
  });

  final int id;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final bool isActive;
}
