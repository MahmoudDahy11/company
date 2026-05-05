import 'package:injectable/injectable.dart';

import '../repositories/clients_repository.dart';

@injectable
class UpdateClientPaymentUseCase {
  const UpdateClientPaymentUseCase(this._repository);

  final ClientsRepository _repository;

  Future<void> call({
    required int paymentId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) {
    return _repository.updatePayment(
      paymentId: paymentId,
      amount: amount,
      paymentDate: paymentDate,
      notes: notes,
    );
  }
}
