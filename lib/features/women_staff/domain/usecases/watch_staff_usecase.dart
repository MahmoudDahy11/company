import 'package:injectable/injectable.dart';

import '../entities/staff_list_item.dart';
import '../repositories/women_staff_repository.dart';

@injectable
class WatchStaffUseCase {
  const WatchStaffUseCase(this._repository);

  final WomenStaffRepository _repository;

  Stream<List<StaffListItem>> call(DateTime month) {
    return _repository.watchStaff(month);
  }
}
