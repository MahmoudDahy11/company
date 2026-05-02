class ClientModelEntry {
  const ClientModelEntry({
    required this.id,
    required this.clientId,
    required this.modelName,
    required this.pieceCount,
    required this.pricePerPiece,
    required this.date,
    this.notes,
  });

  final int id;
  final int clientId;
  final String modelName;
  final int pieceCount;
  final double pricePerPiece;
  final DateTime date;
  final String? notes;

  double get total => pieceCount * pricePerPiece;
}
