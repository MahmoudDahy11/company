import '../entities/staff_details_data.dart';
import '../entities/staff_list_item.dart';

abstract class WomenStaffRepository {
  Stream<List<StaffListItem>> watchStaff(DateTime month);

  Stream<StaffDetailsData> watchStaffDetails(int staffId, DateTime month);

  Future<void> addStaff({required String name, required double monthlySalary});

  Future<void> deleteStaff(int staffId);

  Future<void> updateSalary({
    required int staffId,
    required double monthlySalary,
  });

  Future<void> addAdvance({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  });

  Future<void> deleteAdvance(int advanceId);

  Future<void> addDeduction({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  });

  Future<void> deleteDeduction(int deductionId);
}
