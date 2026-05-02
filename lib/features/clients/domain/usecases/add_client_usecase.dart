import 'package:injectable/injectable.dart';

import '../repositories/clients_repository.dart';

@injectable
class AddClientUseCase {
  const AddClientUseCase(this._repository);

  final ClientsRepository _repository;

  Future<void> call({required String name, String? phone}) {
    return _repository.addClient(name: name, phone: phone);
  }
}
