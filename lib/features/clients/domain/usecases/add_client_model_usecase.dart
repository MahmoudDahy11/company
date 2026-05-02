import 'package:injectable/injectable.dart';

import '../repositories/clients_repository.dart';

@injectable
class AddClientModelUseCase {
  const AddClientModelUseCase(this._repository);

  final ClientsRepository _repository;

  Future<void> call({
    required int clientId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) {
    return _repository.addModel(
      clientId: clientId,
      modelName: modelName,
      pieceCount: pieceCount,
      pricePerPiece: pricePerPiece,
      date: date,
      notes: notes,
    );
  }
}
