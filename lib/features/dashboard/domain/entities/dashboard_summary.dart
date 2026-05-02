class DashboardSummary {
  const DashboardSummary({
    required this.totalWorkerWages,
    required this.totalWomenStaffWages,
    required this.totalThreadPurchases,
    required this.totalClientOutstanding,
    required this.registeredWorkersCount,
    required this.absentDaysCount,
    required this.pendingClientBalancesCount,
    required this.suppliersWithOutstandingCount,
    required this.topWorkers,
    required this.threadPurchasesByMonth,
    required this.clientOutstandingDistribution,
    required this.womenAdvancesByStaff,
  });

  final double totalWorkerWages;
  final double totalWomenStaffWages;
  final double totalThreadPurchases;
  final double totalClientOutstanding;
  final int registeredWorkersCount;
  final int absentDaysCount;
  final int pendingClientBalancesCount;
  final int suppliersWithOutstandingCount;
  final List<DashboardBarPoint> topWorkers;
  final List<DashboardLinePoint> threadPurchasesByMonth;
  final List<DashboardPiePoint> clientOutstandingDistribution;
  final List<DashboardBarPoint> womenAdvancesByStaff;
}

class DashboardBarPoint {
  const DashboardBarPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class DashboardLinePoint {
  const DashboardLinePoint({required this.month, required this.value});

  final int month;
  final double value;
}

class DashboardPiePoint {
  const DashboardPiePoint({required this.label, required this.value});

  final String label;
  final double value;
}
