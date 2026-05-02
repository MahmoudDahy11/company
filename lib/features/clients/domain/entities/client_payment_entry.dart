class ClientPaymentEntry {
  const ClientPaymentEntry({
    required this.id,
    required this.clientId,
    required this.amount,
    required this.paymentDate,
    this.notes,
  });

  final int id;
  final int clientId;
  final double amount;
  final DateTime paymentDate;
  final String? notes;
}
