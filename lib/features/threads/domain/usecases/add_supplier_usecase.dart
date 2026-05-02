import 'package:injectable/injectable.dart';

import '../repositories/threads_repository.dart';

@injectable
class AddSupplierUseCase {
  const AddSupplierUseCase(this._repository);

  final ThreadsRepository _repository;

  Future<void> call({required String name, String? phone}) {
    return _repository.addSupplier(name: name, phone: phone);
  }
}
