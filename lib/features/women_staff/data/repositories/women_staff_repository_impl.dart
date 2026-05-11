import 'package:injectable/injectable.dart';

import '../../domain/entities/staff_details_data.dart';
import '../../domain/entities/staff_list_item.dart';
import '../../domain/repositories/women_staff_repository.dart';
import '../datasources/staff_finance_data_source.dart';
import '../datasources/women_staff_local_data_source.dart';

@LazySingleton(as: WomenStaffRepository)
class WomenStaffRepositoryImpl implements WomenStaffRepository {
  WomenStaffRepositoryImpl(this._staffDataSource, this._financeDataSource);

  final WomenStaffLocalDataSource _staffDataSource;
  final StaffFinanceDataSource _financeDataSource;

  @override
  Stream<List<StaffListItem>> watchStaff(DateTime month) {
    return _staffDataSource.watchStaff(month);
  }

  @override
  Stream<StaffDetailsData> watchStaffDetails(int staffId, DateTime month) {
    return _staffDataSource.watchStaffDetails(staffId, month);
  }

  @override
  Future<void> addStaff({required String name, required double monthlySalary}) {
    return _staffDataSource.addStaff(name: name, monthlySalary: monthlySalary);
  }

  @override
  Future<void> deleteStaff(int staffId) {
    return _staffDataSource.deleteStaff(staffId);
  }

  @override
  Future<void> updateSalary({
    required int staffId,
    required double monthlySalary,
  }) {
    return _staffDataSource.updateSalary(
      staffId: staffId,
      monthlySalary: monthlySalary,
    );
  }

  @override
  Future<void> addAdvance({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _financeDataSource.addAdvance(
      staffId: staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  @override
  Future<void> deleteAdvance(int advanceId) {
    return _financeDataSource.deleteAdvance(advanceId);
  }

  @override
  Future<void> addDeduction({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _financeDataSource.addDeduction(
      staffId: staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  @override
  Future<void> deleteDeduction(int deductionId) {
    return _financeDataSource.deleteDeduction(deductionId);
  }
}
