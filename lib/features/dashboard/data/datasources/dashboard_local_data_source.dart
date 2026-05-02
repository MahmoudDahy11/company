import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_summary.dart';

@lazySingleton
class DashboardLocalDataSource {
  DashboardLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<DashboardSummary> watchSummary(DateTime month) {
    return _watchTrigger().asyncMap((_) => _buildSummary(month));
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
          },
        )
        .watch();
  }

  Future<DashboardSummary> _buildSummary(DateTime month) async {
    final monthRange = _monthRange(month);
    final activeWorkers = await (_database.select(
      _database.workers,
    )..where((t) => t.isActive.equals(true))).get();
    final activeWomen = await (_database.select(
      _database.womenStaffMembers,
    )..where((t) => t.isActive.equals(true))).get();
    final activeClients = await (_database.select(
      _database.clients,
    )..where((t) => t.isActive.equals(true))).get();
    final suppliers = await _database.select(_database.suppliers).get();

    double totalWorkerWages = 0;
    final topWorkerBars = <DashboardBarPoint>[];
    for (final worker in activeWorkers) {
      final summary = await _workerMonthSummary(worker.id, month);
      totalWorkerWages += summary.netSalary;
      topWorkerBars.add(
        DashboardBarPoint(
          label: worker.name,
          value: summary.totalStitchCount.toDouble(),
        ),
      );
    }
    topWorkerBars.sort((a, b) => b.value.compareTo(a.value));

    double totalWomenStaffWages = 0;
    final womenAdvancesBars = <DashboardBarPoint>[];
    for (final staff in activeWomen) {
      final summary = await _womenMonthSummary(staff.id, month);
      totalWomenStaffWages += summary.netSalary;
      womenAdvancesBars.add(
        DashboardBarPoint(label: staff.name, value: summary.totalAdvances),
      );
    }

    final supplierIds = suppliers.map((s) => s.id).toList();
    final monthThreadPurchases = supplierIds.isEmpty
        ? <ThreadPurchase>[]
        : await (_database.select(_database.threadPurchases)
              ..where(
                (t) =>
                    t.supplierId.isIn(supplierIds) &
                    t.purchaseDate.isBetweenValues(
                      monthRange.start,
                      monthRange.end,
                    ),
              ))
            .get();
    final totalThreadPurchases = monthThreadPurchases.fold<double>(
      0,
      (sum, row) => sum + row.price,
    );

    final clientPiePoints = <DashboardPiePoint>[];
    double totalClientOutstanding = 0;
    int pendingClientBalancesCount = 0;
    for (final client in activeClients) {
      final summary = await _clientMonthSummary(client.id, month);
      totalClientOutstanding += summary.outstanding;
      if (summary.outstanding > 0) {
        pendingClientBalancesCount++;
        clientPiePoints.add(
          DashboardPiePoint(label: client.name, value: summary.outstanding),
        );
      }
    }

    int suppliersWithOutstandingCount = 0;
    for (final supplier in suppliers) {
      final summary = await _supplierMonthSummary(supplier.id, month);
      if (summary.outstandingBalance > 0) {
        suppliersWithOutstandingCount++;
      }
    }

    final workerIds = activeWorkers.map((w) => w.id).toList();
    final absentRows = workerIds.isEmpty
        ? <WorkerAbsentDay>[]
        : await (_database.select(_database.workerAbsentDays)
              ..where(
                (t) =>
                    t.workerId.isIn(workerIds) &
                    t.monthStart.equals(
                      DateTime(month.year, month.month),
                    ),
              ))
            .get();
    final absentDaysCount = absentRows.fold<int>(
      0,
      (sum, row) => sum + row.absentDays,
    );

    final threadLines = <DashboardLinePoint>[];
    for (var monthIndex = 1; monthIndex <= 12; monthIndex++) {
      final start = DateTime(month.year, monthIndex);
      final end = DateTime(month.year, monthIndex + 1, 0, 23, 59, 59, 999);
      final rows = supplierIds.isEmpty
          ? <ThreadPurchase>[]
          : await (_database.select(_database.threadPurchases)
                ..where(
                  (t) =>
                      t.supplierId.isIn(supplierIds) &
                      t.purchaseDate.isBetweenValues(start, end),
                ))
              .get();
      threadLines.add(
        DashboardLinePoint(
          month: monthIndex,
          value: rows.fold<double>(0, (sum, row) => sum + row.price),
        ),
      );
    }

    return DashboardSummary(
      totalWorkerWages: totalWorkerWages,
      totalWomenStaffWages: totalWomenStaffWages,
      totalThreadPurchases: totalThreadPurchases,
      totalClientOutstanding: totalClientOutstanding,
      registeredWorkersCount: activeWorkers.length,
      absentDaysCount: absentDaysCount,
      pendingClientBalancesCount: pendingClientBalancesCount,
      suppliersWithOutstandingCount: suppliersWithOutstandingCount,
      topWorkers: topWorkerBars.take(5).toList(),
      threadPurchasesByMonth: threadLines,
      clientOutstandingDistribution: clientPiePoints,
      womenAdvancesByStaff: womenAdvancesBars,
    );
  }

  Future<_WorkerSummary> _workerMonthSummary(
    int workerId,
    DateTime month,
  ) async {
    final normalizedMonth = DateTime(month.year, month.month);
    final worker = await (_database.select(
      _database.workers,
    )..where((t) => t.id.equals(workerId))).getSingle();
    final productions = await (_database.select(
      _database.workerProductionEntries,
    )..where((t) => t.workerId.equals(workerId))).get();
    final advances = await (_database.select(
      _database.workerAdvances,
    )..where((t) => t.workerId.equals(workerId))).get();

    final monthlyBalances = <DateTime, _WorkerSummary>{};
    for (final production in productions) {
      final key = DateTime(production.date.year, production.date.month);
      final existing = monthlyBalances[key] ?? const _WorkerSummary();
      monthlyBalances[key] = existing.copyWith(
        totalStitchCount: existing.totalStitchCount + production.stitchCount,
        totalEarnings:
            existing.totalEarnings +
            await _workerProductionEarnings(
              production.date,
              production.stitchCount,
            ),
      );
    }
    for (final advance in advances) {
      final key = DateTime(advance.date.year, advance.date.month);
      final existing = monthlyBalances[key] ?? const _WorkerSummary();
      monthlyBalances[key] = existing.copyWith(
        totalAdvances: existing.totalAdvances + advance.amount,
      );
    }

    double carryIn = 0;
    DateTime cursor = DateTime(worker.createdAt.year, worker.createdAt.month);
    while (!_isAfterMonth(cursor, normalizedMonth)) {
      final data = monthlyBalances[cursor] ?? const _WorkerSummary();
      final net = data.totalEarnings - data.totalAdvances - carryIn;
      final nextCarry = net < 0 ? -net : 0;
      if (_sameMonth(cursor, normalizedMonth)) {
        return data.copyWith(carryOver: carryIn, netSalary: net);
      }
      carryIn = nextCarry.toDouble();
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return _WorkerSummary(carryOver: carryIn, netSalary: -carryIn);
  }

  Future<double> _workerProductionEarnings(
    DateTime date,
    int stitchCount,
  ) async {
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    final rateRow =
        await (_database.select(_database.stitchRates)
              ..where((t) => t.effectiveFrom.isSmallerOrEqualValue(endOfDay))
              ..orderBy([(t) => OrderingTerm.desc(t.effectiveFrom)])
              ..limit(1))
            .getSingleOrNull();
    final rate = rateRow?.rate ?? 0;
    return (stitchCount / 100000) * rate;
  }

  Future<_WomenSummary> _womenMonthSummary(int staffId, DateTime month) async {
    final normalizedMonth = DateTime(month.year, month.month);
    final member = await (_database.select(
      _database.womenStaffMembers,
    )..where((t) => t.id.equals(staffId))).getSingle();
    final advances = await (_database.select(
      _database.staffAdvances,
    )..where((t) => t.staffId.equals(staffId))).get();

    final monthlyAdvances = <DateTime, double>{};
    for (final advance in advances) {
      final key = DateTime(advance.date.year, advance.date.month);
      monthlyAdvances[key] = (monthlyAdvances[key] ?? 0) + advance.amount;
    }

    double carryIn = 0;
    DateTime cursor = DateTime(member.createdAt.year, member.createdAt.month);
    while (!_isAfterMonth(cursor, normalizedMonth)) {
      final totalAdvances = monthlyAdvances[cursor] ?? 0;
      final net = member.monthlySalary - totalAdvances - carryIn;
      final nextCarry = net < 0 ? -net : 0;
      if (_sameMonth(cursor, normalizedMonth)) {
        return _WomenSummary(
          totalAdvances: totalAdvances,
          carryOver: carryIn,
          netSalary: net,
        );
      }
      carryIn = nextCarry.toDouble();
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return _WomenSummary(
      carryOver: carryIn,
      netSalary: member.monthlySalary - carryIn,
    );
  }

  Future<_ClientSummary> _clientMonthSummary(
    int clientId,
    DateTime month,
  ) async {
    final range = _monthRange(month);
    final models =
        await (_database.select(_database.clientModels)..where(
              (t) =>
                  t.clientId.equals(clientId) &
                  t.date.isBetweenValues(range.start, range.end),
            ))
            .get();
    final payments =
        await (_database.select(_database.clientPayments)..where(
              (t) =>
                  t.clientId.equals(clientId) &
                  t.paymentDate.isBetweenValues(range.start, range.end),
            ))
            .get();
    final totalAmount = models.fold<double>(
      0,
      (sum, row) => sum + (row.pieceCount * row.pricePerPiece),
    );
    final totalPaid = payments.fold<double>(0, (sum, row) => sum + row.amount);
    return _ClientSummary(totalAmount: totalAmount, totalPaid: totalPaid);
  }

  Future<_SupplierSummary> _supplierMonthSummary(
    int supplierId,
    DateTime month,
  ) async {
    final range = _monthRange(month);
    final purchases =
        await (_database.select(_database.threadPurchases)..where(
              (t) =>
                  t.supplierId.equals(supplierId) &
                  t.purchaseDate.isBetweenValues(range.start, range.end),
            ))
            .get();
    final payments =
        await (_database.select(_database.supplierPayments)..where(
              (t) =>
                  t.supplierId.equals(supplierId) &
                  t.paymentDate.isBetweenValues(range.start, range.end),
            ))
            .get();
    final totalPurchased = purchases.fold<double>(
      0,
      (sum, row) => sum + row.price,
    );
    final totalPaid = payments.fold<double>(0, (sum, row) => sum + row.amount);
    return _SupplierSummary(
      totalPurchased: totalPurchased,
      totalPaid: totalPaid,
    );
  }

  ({DateTime start, DateTime end}) _monthRange(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
    return (start: start, end: end);
  }

  bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  bool _isAfterMonth(DateTime value, DateTime target) {
    return value.year > target.year ||
        (value.year == target.year && value.month > target.month);
  }
}

class _WorkerSummary {
  const _WorkerSummary({
    this.totalStitchCount = 0,
    this.totalEarnings = 0,
    this.totalAdvances = 0,
    this.carryOver = 0,
    this.netSalary = 0,
  });

  final int totalStitchCount;
  final double totalEarnings;
  final double totalAdvances;
  final double carryOver;
  final double netSalary;

  _WorkerSummary copyWith({
    int? totalStitchCount,
    double? totalEarnings,
    double? totalAdvances,
    double? carryOver,
    double? netSalary,
  }) {
    return _WorkerSummary(
      totalStitchCount: totalStitchCount ?? this.totalStitchCount,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      totalAdvances: totalAdvances ?? this.totalAdvances,
      carryOver: carryOver ?? this.carryOver,
      netSalary: netSalary ?? this.netSalary,
    );
  }
}

class _WomenSummary {
  const _WomenSummary({
    this.totalAdvances = 0,
    this.carryOver = 0,
    this.netSalary = 0,
  });

  final double totalAdvances;
  final double carryOver;
  final double netSalary;
}

class _ClientSummary {
  const _ClientSummary({this.totalAmount = 0, this.totalPaid = 0});

  final double totalAmount;
  final double totalPaid;

  double get outstanding => totalAmount - totalPaid;
}

class _SupplierSummary {
  const _SupplierSummary({this.totalPurchased = 0, this.totalPaid = 0});

  final double totalPurchased;
  final double totalPaid;

  double get outstandingBalance => totalPurchased - totalPaid;
}
