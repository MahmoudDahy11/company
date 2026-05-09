class SupplierFormResult {
  const SupplierFormResult({required this.name, this.phone});

  final String name;
  final String? phone;
}

class PurchaseFormResult {
  const PurchaseFormResult({
    required this.itemName,
    required this.colorNumber,
    required this.purchaseDate,
    required this.price,
    required this.quantity,
    required this.unit,
    this.notes,
    this.purchaseId,
  });

  final String itemName;
  final String colorNumber;
  final DateTime purchaseDate;
  final double price;
  final double quantity;
  final String unit;
  final String? notes;
  final int? purchaseId;
}

class SupplierPaymentFormResult {
  const SupplierPaymentFormResult({
    required this.amount,
    required this.paymentDate,
    this.notes,
    this.paymentId,
  });

  final double amount;
  final DateTime paymentDate;
  final String? notes;
  final int? paymentId;
}
