import 'package:injectable/injectable.dart';

import '../repositories/threads_repository.dart';

@injectable
class AddSupplierPaymentUseCase {
  const AddSupplierPaymentUseCase(this._repository);

  final ThreadsRepository _repository;

  Future<void> call({
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) {
    return _repository.addPayment(
      supplierId: supplierId,
      amount: amount,
      paymentDate: paymentDate,
      notes: notes,
    );
  }
}
