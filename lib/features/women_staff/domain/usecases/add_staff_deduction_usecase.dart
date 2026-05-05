import 'package:injectable/injectable.dart';
import '../repositories/women_staff_repository.dart';

@injectable
class AddStaffDeductionUseCase {
  const AddStaffDeductionUseCase(this._repository);

  final WomenStaffRepository _repository;

  Future<void> call({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _repository.addDeduction(
      staffId: staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }
}
