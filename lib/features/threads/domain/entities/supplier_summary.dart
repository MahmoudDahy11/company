class SupplierSummary {
  const SupplierSummary({
    required this.totalPurchased,
    required this.totalPaid,
    required this.outstandingBalance,
  });

  final double totalPurchased;
  final double totalPaid;
  final double outstandingBalance;
}
