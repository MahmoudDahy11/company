import 'package:injectable/injectable.dart';

import '../repositories/clients_repository.dart';

@injectable
class DeleteClientModelUseCase {
  const DeleteClientModelUseCase(this._repository);

  final ClientsRepository _repository;

  Future<void> call(int modelId) => _repository.deleteModel(modelId);
}
