import 'package:injectable/injectable.dart';

import '../repositories/threads_repository.dart';

@injectable
class DeleteSupplierPaymentUseCase {
  const DeleteSupplierPaymentUseCase(this._repository);

  final ThreadsRepository _repository;

  Future<void> call(int paymentId) => _repository.deletePayment(paymentId);
}
