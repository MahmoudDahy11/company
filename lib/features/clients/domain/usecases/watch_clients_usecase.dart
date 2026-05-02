import 'package:injectable/injectable.dart';

import '../entities/client_list_item.dart';
import '../repositories/clients_repository.dart';

@injectable
class WatchClientsUseCase {
  const WatchClientsUseCase(this._repository);

  final ClientsRepository _repository;

  Stream<List<ClientListItem>> call(DateTime month) =>
      _repository.watchClients(month);
}
