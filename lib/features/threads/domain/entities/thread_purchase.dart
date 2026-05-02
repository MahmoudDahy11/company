class ThreadPurchase {
  const ThreadPurchase({
    required this.id,
    required this.supplierId,
    required this.itemName,
    required this.colorNumber,
    required this.purchaseDate,
    required this.price,
    required this.quantity,
    required this.unit,
    this.notes,
  });

  final int id;
  final int supplierId;
  final String itemName;
  final String colorNumber;
  final DateTime purchaseDate;
  final double price;
  final double quantity;
  final String unit;
  final String? notes;
}
