import 'package:injectable/injectable.dart';

import '../repositories/threads_repository.dart';

@injectable
class DeletePurchaseUseCase {
  const DeletePurchaseUseCase(this._repository);

  final ThreadsRepository _repository;

  Future<void> call(int purchaseId) => _repository.deletePurchase(purchaseId);
}
