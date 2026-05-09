import 'dart:async';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/financial_filter.dart';
import '../../../women_staff/domain/usecases/calculate_women_staff_salary_usecase.dart';
import '../../../clients/domain/usecases/get_client_balance_usecase.dart';
import 'dashboard_summary_builder.dart';

@lazySingleton
class DashboardLocalDataSource {
  const DashboardLocalDataSource(
    this._database,
    this._calculateWomenStaffSalaryUseCase,
    this._getClientBalanceUseCase,
  );

  final AppDatabase _database;
  final CalculateWomenStaffSalaryUseCase _calculateWomenStaffSalaryUseCase;
  final GetClientBalanceUseCase _getClientBalanceUseCase;

  Stream<DashboardSummary> watchSummary(
    DateTime month,
    FinancialFilter financialFilter,
  ) {
    return _watchTrigger().switchMap(
      (_) => Stream.fromFuture(_buildSummary(month, financialFilter)),
    );
  }

  Stream<List<QueryRow>> _watchTrigger() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.workers,
            _database.workerProductionEntries,
            _database.workerAdvances,
            _database.stitchRates,
            _database.workerAbsentDays,
            _database.womenStaffMembers,
            _database.staffAdvances,
            _database.suppliers,
            _database.threadPurchases,
            _database.supplierPayments,
            _database.clients,
            _database.clientModels,
            _database.clientPayments,
            _database.maintenanceFaultRecords,
          },
        )
        .watch()
        .debounceTime(const Duration(seconds: 2));
  }

  Future<DashboardSummary> _buildSummary(
    DateTime month,
    FinancialFilter filter,
  ) async {
    final builder = DashboardSummaryBuilder(
      _database,
      _calculateWomenStaffSalaryUseCase,
      _getClientBalanceUseCase,
    );
    return builder.build(month, filter);
  }
}
