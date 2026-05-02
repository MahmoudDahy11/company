class ClientListItem {
  const ClientListItem({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.totalPaid,
    required this.outstanding,
  });

  final int id;
  final String name;
  final double totalAmount;
  final double totalPaid;
  final double outstanding;
}
