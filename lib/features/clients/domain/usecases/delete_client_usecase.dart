import 'package:injectable/injectable.dart';

import '../repositories/clients_repository.dart';

@injectable
class DeleteClientUseCase {
  const DeleteClientUseCase(this._repository);

  final ClientsRepository _repository;

  Future<void> call(int clientId) => _repository.deleteClient(clientId);
}
