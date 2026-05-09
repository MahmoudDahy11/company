import 'dart:async';
import 'dart:developer';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/financial_filter.dart';
import '../../../women_staff/domain/usecases/calculate_women_staff_salary_usecase.dart';
import '../../../clients/domain/usecases/get_client_balance_usecase.dart';

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
    FinancialFilter financialFilter,
  ) async {
    log('DEBUG: Dashboard: Building summary for $month');
    final monthRange = _monthRange(month);
    final rate = await _getRateForMonth(month);
    log('DEBUG: Dashboard: Monthly rate: $rate');

    // 1. Optimized Workers Summary (One SQL Pass)
    log('DEBUG: Dashboard: Fetching worker totals...');
    final workerTotals = await _database
        .customSelect(
          '''
      SELECT 
        COUNT(*) as count,
        COALESCE(SUM(current_stitches), 0) as total_stitches,
        COALESCE(SUM(current_advances), 0.0) as total_advances,
        COALESCE(SUM(current_deductions), 0.0) as total_deductions,
        COALESCE(SUM(current_earnings), 0.0) as total_earnings,
        COALESCE(SUM(carry_in), 0.0) as total_carry_in
      FROM (
        SELECT 
          w.id,
          COALESCE((SELECT SUM(stitch_count) FROM worker_production_entries WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0) as current_stitches,
          COALESCE((SELECT SUM(amount) FROM worker_advances WHERE worker_id = w.id AND date BETWEEN ? AND ? AND carried_over = 0), 0.0) as current_advances,
          COALESCE((SELECT SUM(amount) FROM worker_deductions WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0.0) as current_deductions,
          COALESCE((SELECT amount FROM worker_advances WHERE worker_id = w.id AND date = ? AND carried_over = 1 LIMIT 1), 0.0) as carry_in,
          ((COALESCE((SELECT SUM(stitch_count) FROM worker_production_entries WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0) / 100000.0) * ?) as current_earnings
        FROM workers w
        WHERE w.is_active = 1
      )
      ''',
          variables: [
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
            Variable.withReal(rate),
          ],
        )
        .getSingle();

    final wEarnings = workerTotals.read<double?>('total_earnings') ?? 0.0;
    final wDeductions = workerTotals.read<double?>('total_deductions') ?? 0.0;
    log(
      'DEBUG: Dashboard: Worker Totals -> Earnings: $wEarnings, Deductions: $wDeductions',
    );

    final totalWorkerWages = wEarnings - wDeductions;
    log('DEBUG: Dashboard: Total Worker Wages calculated: $totalWorkerWages');

    // 2. Top Workers
    log('DEBUG: Dashboard: Fetching top workers...');
    final topWorkersQuery = await _database
        .customSelect(
          '''
      SELECT w.name, COALESCE(SUM(e.stitch_count), 0) as total_stitches
      FROM workers w
      JOIN worker_production_entries e ON w.id = e.worker_id
      WHERE w.is_active = 1 AND e.date BETWEEN ? AND ?
      GROUP BY w.id
      ORDER BY total_stitches DESC
      LIMIT 5
      ''',
          variables: [
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
          ],
        )
        .get();

    final topWorkerBars = topWorkersQuery.map((row) {
      return DashboardBarPoint(
        label: row.read<String?>('name') ?? '',
        value: (row.read<int?>('total_stitches') ?? 0).toDouble(),
      );
    }).toList();
    log('DEBUG: Dashboard: Top workers count: ${topWorkerBars.length}');

    // 3. Women Staff (Optimized)
    log('DEBUG: Dashboard: Fetching women staff totals...');
    final womenTotals = await _database
        .customSelect(
          '''
      SELECT 
        COALESCE(SUM(monthly_salary), 0.0) as total_salaries,
        COALESCE(SUM(current_advances), 0.0) as total_advances,
        COALESCE(SUM(carry_in), 0.0) as total_carry_in
      FROM (
        SELECT 
          m.monthly_salary,
          COALESCE((SELECT SUM(amount) FROM staff_advances WHERE staff_id = m.id AND date BETWEEN ? AND ?), 0.0) as current_advances,
          COALESCE((SELECT amount FROM staff_advances WHERE staff_id = m.id AND date = ? AND carried_over = 1 LIMIT 1), 0.0) as carry_in
        FROM women_staff_members m
        WHERE m.is_active = 1
      )
      ''',
          variables: [
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
            Variable.withDateTime(monthRange.start),
          ],
        )
        .getSingle();

    final sSalaries = womenTotals.read<double?>('total_salaries') ?? 0.0;
    final sAdvances = womenTotals.read<double?>('total_advances') ?? 0.0;
    final sCarryIn = womenTotals.read<double?>('total_carry_in') ?? 0.0;
    log(
      'DEBUG: Dashboard: Staff Totals -> Salaries: $sSalaries, Advances: $sAdvances, CarryIn: $sCarryIn',
    );

    final totalWomenStaffWages = _calculateWomenStaffSalaryUseCase(
      monthlySalary: sSalaries,
      advances: sAdvances,
      carryOver: sCarryIn,
    );
    log(
      'DEBUG: Dashboard: Total Women Staff Wages calculated: $totalWomenStaffWages',
    );

    // 4. Thread Purchases Trend (Aggregated in Dart for cross-platform safety)
    log('DEBUG: Dashboard: Fetching thread purchases trend...');
    final yearStart = DateTime(month.year, 1, 1);
    final yearEnd = DateTime(month.year, 12, 31, 23, 59, 59);

    final allThreadPurchases = await (_database.select(
      _database.threadPurchases,
    )..where((t) => t.purchaseDate.isBetweenValues(yearStart, yearEnd))).get();

    final threadLines = List.generate(12, (i) {
      final monthIdx = i + 1;
      final total = allThreadPurchases
          .where((p) => p.purchaseDate.month == monthIdx)
          .fold<double>(0, (sum, p) => sum + p.price);
      return DashboardLinePoint(month: monthIdx, value: total);
    });
    log('DEBUG: Dashboard: Thread trend points: ${threadLines.length}');

    // 5. Financial Summary
    final financialRange = _financialRange(month, financialFilter);
    log(
      'DEBUG: Dashboard: Fetching client financials for range: $financialRange',
    );

    // Client Financials
    final clientAnnualQuery = await _database
        .customSelect(
          '''
      SELECT 
        c.id, c.name,
        COALESCE(SUM(m.piece_count * m.price_per_piece), 0.0) as total_work,
        COALESCE((SELECT SUM(amount) FROM client_payments WHERE client_id = c.id AND payment_date BETWEEN ? AND ?), 0.0) as total_paid
      FROM clients c
      LEFT JOIN client_models m ON c.id = m.client_id AND m.date BETWEEN ? AND ?
      WHERE c.is_active = 1
      GROUP BY c.id
      ORDER BY (total_work - total_paid) DESC
      ''',
          variables: [
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
          ],
        )
        .get();

    double totalDueFromClients = 0;
    final clientAnnualSummaries = <ClientAnnualSummary>[];
    final clientPiePoints = <DashboardPiePoint>[];

    for (final row in clientAnnualQuery) {
      final work = row.read<double?>('total_work') ?? 0.0;
      final paid = row.read<double?>('total_paid') ?? 0.0;
      final remaining = _getClientBalanceUseCase(
        totalAmount: work,
        totalPaid: paid,
      );

      if (remaining > 0) {
        totalDueFromClients += remaining;
        clientPiePoints.add(
          DashboardPiePoint(
            label: row.read<String?>('name') ?? '',
            value: remaining,
          ),
        );
      }

      clientAnnualSummaries.add(
        ClientAnnualSummary(
          clientId: row.read<int?>('id') ?? 0,
          name: row.read<String?>('name') ?? '',
          totalWork: work,
          totalPaid: paid,
          remaining: remaining,
        ),
      );
    }
    log('DEBUG: Dashboard: Total Due from Clients: $totalDueFromClients');

    // Supplier Financials
    log('DEBUG: Dashboard: Fetching supplier financials...');
    final supplierAnnualQuery = await _database
        .customSelect(
          '''
      SELECT 
        s.id, s.name,
        COALESCE(SUM(p.price), 0.0) as total_purchased,
        COALESCE((SELECT SUM(amount) FROM supplier_payments WHERE supplier_id = s.id AND payment_date BETWEEN ? AND ?), 0.0) as total_paid
      FROM suppliers s
      LEFT JOIN thread_purchases p ON s.id = p.supplier_id AND p.purchase_date BETWEEN ? AND ?
      GROUP BY s.id
      ORDER BY (total_purchased - total_paid) DESC
      ''',
          variables: [
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
          ],
        )
        .get();

    double totalDueToSuppliers = 0;
    final supplierAnnualSummaries = <SupplierAnnualSummary>[];
    for (final row in supplierAnnualQuery) {
      final purchased = row.read<double?>('total_purchased') ?? 0.0;
      final paid = row.read<double?>('total_paid') ?? 0.0;
      final remaining = purchased - paid;

      totalDueToSuppliers += remaining;
      supplierAnnualSummaries.add(
        SupplierAnnualSummary(
          supplierId: row.read<int?>('id') ?? 0,
          name: row.read<String?>('name') ?? '',
          totalPurchases: purchased,
          totalPaid: paid,
          remaining: remaining,
        ),
      );
    }
    log('DEBUG: Dashboard: Total Due to Suppliers: $totalDueToSuppliers');

    // 6. Maintenance Cost
    log('DEBUG: Dashboard: Fetching maintenance cost...');
    final maintenanceRow = await _database
        .customSelect(
          'SELECT COALESCE(SUM(total_cost), 0.0) as total_cost FROM maintenance_fault_records WHERE created_at BETWEEN ? AND ?',
          variables: [
            Variable.withDateTime(monthRange.start),
            Variable.withDateTime(monthRange.end),
          ],
        )
        .getSingle();
    final totalMaintenanceCost =
        maintenanceRow.read<double?>('total_cost') ?? 0.0;
    log('DEBUG: Dashboard: Total Maintenance Cost: $totalMaintenanceCost');

    // Yearly maintenance cost
    final maintenanceYearRow = await _database
        .customSelect(
          'SELECT COALESCE(SUM(total_cost), 0.0) as total_cost FROM maintenance_fault_records WHERE created_at BETWEEN ? AND ?',
          variables: [
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
          ],
        )
        .getSingle();
    final totalMaintenanceCostYear =
        maintenanceYearRow.read<double?>('total_cost') ?? 0.0;
    log(
      'DEBUG: Dashboard: Total Maintenance Cost (Year): $totalMaintenanceCostYear',
    );

    // Yearly worker wages
    log('DEBUG: Dashboard: Fetching yearly worker wages...');
    final yearRate = await _getRateForDate(financialRange.end);
    final workerYearTotals = await _database
        .customSelect(
          '''
      SELECT 
        COALESCE(SUM(current_stitches), 0) as total_stitches,
        COALESCE(SUM(current_advances), 0.0) as total_advances,
        COALESCE(SUM(current_deductions), 0.0) as total_deductions,
        COALESCE(SUM(current_earnings), 0.0) as total_earnings,
        COALESCE(SUM(carry_in), 0.0) as total_carry_in
      FROM (
        SELECT 
          w.id,
          COALESCE((SELECT SUM(stitch_count) FROM worker_production_entries WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0) as current_stitches,
          COALESCE((SELECT SUM(amount) FROM worker_advances WHERE worker_id = w.id AND date BETWEEN ? AND ? AND carried_over = 0), 0.0) as current_advances,
          COALESCE((SELECT SUM(amount) FROM worker_deductions WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0.0) as current_deductions,
          COALESCE((SELECT amount FROM worker_advances WHERE worker_id = w.id AND date = ? AND carried_over = 1 LIMIT 1), 0.0) as carry_in,
          ((COALESCE((SELECT SUM(stitch_count) FROM worker_production_entries WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0) / 100000.0) * ?) as current_earnings
        FROM workers w
        WHERE w.is_active = 1
      )
      ''',
          variables: [
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.start),
            Variable.withDateTime(financialRange.end),
            Variable.withReal(yearRate),
          ],
        )
        .getSingle();

    final wyEarnings = workerYearTotals.read<double?>('total_earnings') ?? 0.0;
    final wyDeductions =
        workerYearTotals.read<double?>('total_deductions') ?? 0.0;

    final totalWorkerWagesYear = wyEarnings - wyDeductions;
    log('DEBUG: Dashboard: Total Worker Wages (Year): $totalWorkerWagesYear');

    // 7. Final Dashboard Summary Construction
    log('DEBUG: Dashboard: Finalizing summary construction...');
    return DashboardSummary(
      totalWorkerWages: totalWorkerWages,
      totalWomenStaffWages: totalWomenStaffWages,
      totalThreadPurchases: threadLines[month.month - 1].value,
      totalClientOutstanding: totalDueFromClients,
      totalMaintenanceCost: totalMaintenanceCost,
      registeredWorkersCount: workerTotals.read<int?>('count') ?? 0,
      absentDaysCount: await _getAbsentDaysCount(month),
      pendingClientBalancesCount: clientPiePoints.length,
      suppliersWithOutstandingCount: supplierAnnualSummaries
          .where((s) => s.remaining > 0)
          .length,
      topWorkers: topWorkerBars,
      threadPurchasesByMonth: threadLines,
      clientOutstandingDistribution: clientPiePoints,
      womenAdvancesByStaff: await _getWomenAdvancesBars(month),
      financialSummary: FinancialSummary(
        totalDueFromClients: totalDueFromClients,
        totalDueToSuppliers: totalDueToSuppliers,
        totalMaintenanceCost: totalMaintenanceCostYear,
        totalWorkerWagesYear: totalWorkerWagesYear,
        clientSummaries: clientAnnualSummaries,
        supplierSummaries: supplierAnnualSummaries,
      ),
    );
  }

  Future<double> _getRateForMonth(DateTime month) async {
    final endOfMonth = DateTime(
      month.year,
      month.month + 1,
      0,
      23,
      59,
      59,
      999,
    );
    return _getRateForDate(endOfMonth);
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

  Future<int> _getAbsentDaysCount(DateTime month) async {
    final normalizedMonth = DateTime(month.year, month.month);
    final query = await _database
        .customSelect(
          'SELECT SUM(absent_days) as total FROM worker_absent_days WHERE month_start = ?',
          variables: [Variable.withDateTime(normalizedMonth)],
        )
        .getSingle();
    return query.read<int?>('total') ?? 0;
  }

  Future<List<DashboardBarPoint>> _getWomenAdvancesBars(DateTime month) async {
    final range = _monthRange(month);
    final query = await _database
        .customSelect(
          '''
      SELECT m.name, COALESCE(SUM(a.amount), 0.0) as total_advances
      FROM women_staff_members m
      JOIN staff_advances a ON m.id = a.staff_id
      WHERE m.is_active = 1 AND a.date BETWEEN ? AND ?
      GROUP BY m.id
      ''',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
          ],
        )
        .get();
    return query.map((row) {
      return DashboardBarPoint(
        label: row.read<String?>('name') ?? '',
        value: row.read<double?>('total_advances') ?? 0.0,
      );
    }).toList();
  }

  ({DateTime start, DateTime end}) _financialRange(
    DateTime month,
    FinancialFilter filter,
  ) {
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
    switch (filter) {
      case FinancialFilter.last3Months:
        return (start: DateTime(month.year, month.month - 2), end: end);
      case FinancialFilter.last6Months:
        return (start: DateTime(month.year, month.month - 5), end: end);
      case FinancialFilter.lastYear:
        return (start: DateTime(month.year, month.month - 11), end: end);
    }
  }

  ({DateTime start, DateTime end}) _monthRange(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
    return (start: start, end: end);
  }
}
