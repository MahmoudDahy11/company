class ClientSummary {
  const ClientSummary({
    required this.totalAmount,
    required this.totalPaid,
    required this.outstanding,
  });

  final double totalAmount;
  final double totalPaid;
  final double outstanding;
}
