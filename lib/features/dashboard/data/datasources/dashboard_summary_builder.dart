import 'dart:developer';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/financial_filter.dart';
import '../../../women_staff/domain/usecases/calculate_women_staff_salary_usecase.dart';
import '../../../clients/domain/usecases/get_client_balance_usecase.dart';
import 'dashboard_worker_queries.dart';
import 'dashboard_staff_queries.dart';
import 'dashboard_client_queries.dart';
import 'dashboard_supplier_queries.dart';
import 'dashboard_date_utils.dart';

class DashboardSummaryBuilder {
  DashboardSummaryBuilder(
    this._database,
    this._calculateWomenStaffSalaryUseCase,
    this._getClientBalanceUseCase,
  );

  final AppDatabase _database;
  final CalculateWomenStaffSalaryUseCase _calculateWomenStaffSalaryUseCase;
  final GetClientBalanceUseCase _getClientBalanceUseCase;

  Future<DashboardSummary> build(DateTime month, FinancialFilter filter) async {
    log('DEBUG: Dashboard: Building summary for $month');
    final mRange = monthRange(month);
    final fRange = financialRange(month, filter);
    final rate = await _getRateForMonth(month);
    final yearRate = await _getRateForDate(fRange.end);

    final workerQ = DashboardWorkerQueries(_database);
    final staffQ = DashboardStaffQueries(_database);
    final clientQ = DashboardClientQueries(_database, _getClientBalanceUseCase);
    final supplierQ = DashboardSupplierQueries(_database);

    final workerTotals = await workerQ.fetchWorkerTotals(mRange, rate);
    log(
      'DEBUG: Dashboard: Total Worker Wages: ${workerTotals.earnings - workerTotals.deductions}',
    );

    final staffData = await staffQ.fetchWomenStaffTotals(mRange);
    final womenWages = _calculateWomenStaffSalaryUseCase(
      monthlySalary: staffData.salaries,
      advances: staffData.advances,
      carryOver: staffData.carryIn,
    );
    log('DEBUG: Dashboard: Total Women Staff Wages: $womenWages');

    final topWorkers = await workerQ.fetchTopWorkers(mRange);
    final threadLines = await supplierQ.fetchThreadPurchasesByYear(month.year);
    log('DEBUG: Dashboard: Thread trend points: ${threadLines.length}');

    log('DEBUG: Dashboard: Fetching client financials...');
    final (clientSummaries, clientPiePoints, totalDueFromClients) =
        await clientQ.fetchClientData(fRange);

    log('DEBUG: Dashboard: Fetching supplier financials...');
    final (supplierSummaries, totalDueToSuppliers) = await supplierQ
        .fetchSupplierData(fRange);

    log('DEBUG: Dashboard: Fetching maintenance cost...');
    final maintenanceCost = await supplierQ.fetchMaintenanceCost(mRange);
    final maintenanceCostYear = await supplierQ.fetchMaintenanceCost(fRange);

    final yearWorkerTotals = await workerQ.fetchWorkerTotals(fRange, yearRate);
    final totalWorkerWagesYear =
        yearWorkerTotals.earnings - yearWorkerTotals.deductions;
    log('DEBUG: Dashboard: Total Worker Wages (Year): $totalWorkerWagesYear');

    log('DEBUG: Dashboard: Finalizing summary...');
    return DashboardSummary(
      totalWorkerWages: workerTotals.earnings - workerTotals.deductions,
      totalWomenStaffWages: womenWages,
      totalThreadPurchases: threadLines[month.month - 1].value,
      totalClientOutstanding: totalDueFromClients,
      totalMaintenanceCost: maintenanceCost,
      registeredWorkersCount: workerTotals.count,
      absentDaysCount: await workerQ.fetchAbsentDays(month),
      pendingClientBalancesCount: clientPiePoints.length,
      suppliersWithOutstandingCount: supplierSummaries
          .where((s) => s.remaining > 0)
          .length,
      topWorkers: topWorkers,
      threadPurchasesByMonth: threadLines,
      clientOutstandingDistribution: clientPiePoints,
      womenAdvancesByStaff: await staffQ.fetchWomenAdvances(mRange),
      financialSummary: FinancialSummary(
        totalDueFromClients: totalDueFromClients,
        totalDueToSuppliers: totalDueToSuppliers,
        totalMaintenanceCost: maintenanceCostYear,
        totalWorkerWagesYear: totalWorkerWagesYear,
        clientSummaries: clientSummaries,
        supplierSummaries: supplierSummaries,
      ),
    );
  }

  Future<double> _getRateForMonth(DateTime month) async {
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
    return _getRateForDate(end);
  }

  Future<double> _getRateForDate(DateTime date) async {
    final row =
        await (_database.select(_database.stitchRates)
              ..where((t) => t.effectiveFrom.isSmallerOrEqualValue(date))
              ..orderBy([(t) => OrderingTerm.desc(t.effectiveFrom)])
              ..limit(1))
            .getSingleOrNull();
    return row?.rate ?? 0.0;
  }
}
