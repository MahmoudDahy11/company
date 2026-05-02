class SupplierPaymentEntry {
  const SupplierPaymentEntry({
    required this.id,
    required this.supplierId,
    required this.amount,
    required this.paymentDate,
    this.notes,
  });

  final int id;
  final int supplierId;
  final double amount;
  final DateTime paymentDate;
  final String? notes;
}
