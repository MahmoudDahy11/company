import 'package:injectable/injectable.dart';

import '../repositories/clients_repository.dart';

@injectable
class DeleteClientPaymentUseCase {
  const DeleteClientPaymentUseCase(this._repository);

  final ClientsRepository _repository;

  Future<void> call(int paymentId) => _repository.deletePayment(paymentId);
}
