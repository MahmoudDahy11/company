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
    this.financialSummary,
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
  final FinancialSummary? financialSummary;
}

class FinancialSummary {
  const FinancialSummary({
    required this.totalDueFromClients,
    required this.totalDueToSuppliers,
    required this.clientSummaries,
    required this.supplierSummaries,
  });

  final double totalDueFromClients;
  final double totalDueToSuppliers;
  final List<ClientAnnualSummary> clientSummaries;
  final List<SupplierAnnualSummary> supplierSummaries;
}

class ClientAnnualSummary {
  const ClientAnnualSummary({
    required this.clientId,
    required this.name,
    required this.totalWork,
    required this.totalPaid,
    required this.remaining,
  });

  final int clientId;
  final String name;
  final double totalWork;
  final double totalPaid;
  final double remaining;
}

class SupplierAnnualSummary {
  const SupplierAnnualSummary({
    required this.supplierId,
    required this.name,
    required this.totalPurchases,
    required this.totalPaid,
    required this.remaining,
  });

  final int supplierId;
  final String name;
  final double totalPurchases;
  final double totalPaid;
  final double remaining;
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
