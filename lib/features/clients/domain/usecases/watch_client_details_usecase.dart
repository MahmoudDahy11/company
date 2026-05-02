import 'package:injectable/injectable.dart';

import '../entities/client_details_data.dart';
import '../repositories/clients_repository.dart';

@injectable
class WatchClientDetailsUseCase {
  const WatchClientDetailsUseCase(this._repository);

  final ClientsRepository _repository;

  Stream<ClientDetailsData> call(int clientId, DateTime month) =>
      _repository.watchClientDetails(clientId, month);
}
