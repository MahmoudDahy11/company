import '../entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Stream<DashboardSummary> watchSummary(DateTime month);
}
