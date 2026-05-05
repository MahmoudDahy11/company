import 'package:injectable/injectable.dart';

import '../repositories/clients_repository.dart';

@injectable
class UpdateClientModelUseCase {
  const UpdateClientModelUseCase(this._repository);

  final ClientsRepository _repository;

  Future<void> call({
    required int modelId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) {
    return _repository.updateModel(
      modelId: modelId,
      modelName: modelName,
      pieceCount: pieceCount,
      pricePerPiece: pricePerPiece,
      date: date,
      notes: notes,
    );
  }
}
