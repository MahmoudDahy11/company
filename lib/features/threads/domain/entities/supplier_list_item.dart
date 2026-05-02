class SupplierListItem {
  const SupplierListItem({
    required this.id,
    required this.name,
    required this.totalPurchased,
    required this.totalPaid,
    required this.outstandingBalance,
  });

  final int id;
  final String name;
  final double totalPurchased;
  final double totalPaid;
  final double outstandingBalance;
}
