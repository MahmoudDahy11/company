import '../entities/dashboard_summary.dart';
import '../entities/financial_filter.dart';

abstract class DashboardRepository {
  Stream<DashboardSummary> watchSummary(
    DateTime month,
    FinancialFilter financialFilter,
  );
}
