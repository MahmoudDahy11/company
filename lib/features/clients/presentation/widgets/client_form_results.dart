class ClientFormResult {
  const ClientFormResult({required this.name, this.phone});

  final String name;
  final String? phone;
}

class ClientModelFormResult {
  const ClientModelFormResult({
    required this.modelName,
    required this.pieceCount,
    required this.pricePerPiece,
    required this.date,
    this.notes,
    this.modelId,
  });

  final String modelName;
  final int pieceCount;
  final double pricePerPiece;
  final DateTime date;
  final String? notes;
  final int? modelId;
}

class ClientPaymentFormResult {
  const ClientPaymentFormResult({
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
