import 'package:injectable/injectable.dart';

import '../entities/staff_details_data.dart';
import '../repositories/women_staff_repository.dart';

@injectable
class WatchStaffDetailsUseCase {
  const WatchStaffDetailsUseCase(this._repository);

  final WomenStaffRepository _repository;

  Stream<StaffDetailsData> call(int staffId, DateTime month) {
    return _repository.watchStaffDetails(staffId, month);
  }
}
