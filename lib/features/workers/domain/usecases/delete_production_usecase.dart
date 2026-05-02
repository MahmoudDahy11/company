import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class DeleteProductionUseCase {
  const DeleteProductionUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call(int productionId) {
    return _repository.deleteProduction(productionId);
  }
}
