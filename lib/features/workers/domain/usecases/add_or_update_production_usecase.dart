import 'package:injectable/injectable.dart';

import '../repositories/workers_repository.dart';

@injectable
class AddOrUpdateProductionUseCase {
  const AddOrUpdateProductionUseCase(this._repository);

  final WorkersRepository _repository;

  Future<void> call({
    int? productionId,
    required int workerId,
    required DateTime date,
    required int stitchCount,
    String? notes,
  }) {
    return _repository.addOrUpdateProduction(
      productionId: productionId,
      workerId: workerId,
      date: date,
      stitchCount: stitchCount,
      notes: notes,
    );
  }
}
