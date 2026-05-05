import 'package:injectable/injectable.dart';

import '../../domain/entities/staff_details_data.dart';
import '../../domain/entities/staff_list_item.dart';
import '../../domain/repositories/women_staff_repository.dart';
import '../datasources/women_staff_local_data_source.dart';

@LazySingleton(as: WomenStaffRepository)
class WomenStaffRepositoryImpl implements WomenStaffRepository {
  WomenStaffRepositoryImpl(this._localDataSource);

  final WomenStaffLocalDataSource _localDataSource;

  @override
  Stream<List<StaffListItem>> watchStaff(DateTime month) {
    return _localDataSource.watchStaff(month);
  }

  @override
  Stream<StaffDetailsData> watchStaffDetails(int staffId, DateTime month) {
    return _localDataSource.watchStaffDetails(staffId, month);
  }

  @override
  Future<void> addStaff({required String name, required double monthlySalary}) {
    return _localDataSource.addStaff(name: name, monthlySalary: monthlySalary);
  }

  @override
  Future<void> deleteStaff(int staffId) {
    return _localDataSource.deleteStaff(staffId);
  }

  @override
  Future<void> updateSalary({
    required int staffId,
    required double monthlySalary,
  }) {
    return _localDataSource.updateSalary(
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
    return _localDataSource.addAdvance(
      staffId: staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  @override
  Future<void> deleteAdvance(int advanceId) {
    return _localDataSource.deleteAdvance(advanceId);
  }

  @override
  Future<void> addDeduction({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _localDataSource.addDeduction(
      staffId: staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  @override
  Future<void> deleteDeduction(int deductionId) {
    return _localDataSource.deleteDeduction(deductionId);
  }
}
