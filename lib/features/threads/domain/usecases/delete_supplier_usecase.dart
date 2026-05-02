import 'package:injectable/injectable.dart';

import '../repositories/threads_repository.dart';

@injectable
class DeleteSupplierUseCase {
  const DeleteSupplierUseCase(this._repository);

  final ThreadsRepository _repository;

  Future<void> call(int supplierId) => _repository.deleteSupplier(supplierId);
}
