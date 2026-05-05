import 'package:injectable/injectable.dart';

import '../repositories/threads_repository.dart';

@injectable
class AddOrUpdateSupplierPaymentUseCase {
  const AddOrUpdateSupplierPaymentUseCase(this._repository);

  final ThreadsRepository _repository;

  Future<void> call({
    int? paymentId,
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) {
    return _repository.addOrUpdatePayment(
      paymentId: paymentId,
      supplierId: supplierId,
      amount: amount,
      paymentDate: paymentDate,
      notes: notes,
    );
  }
}
