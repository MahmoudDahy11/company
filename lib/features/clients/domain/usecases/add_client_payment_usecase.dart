import 'package:injectable/injectable.dart';

import '../repositories/clients_repository.dart';

@injectable
class AddClientPaymentUseCase {
  const AddClientPaymentUseCase(this._repository);

  final ClientsRepository _repository;

  Future<void> call({
    required int clientId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) {
    return _repository.addPayment(
      clientId: clientId,
      amount: amount,
      paymentDate: paymentDate,
      notes: notes,
    );
  }
}
