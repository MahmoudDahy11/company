import 'package:injectable/injectable.dart';
import '../repositories/women_staff_repository.dart';

@injectable
class DeleteStaffDeductionUseCase {
  const DeleteStaffDeductionUseCase(this._repository);

  final WomenStaffRepository _repository;

  Future<void> call(int deductionId) {
    return _repository.deleteDeduction(deductionId);
  }
}
