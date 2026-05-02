import 'package:injectable/injectable.dart';

import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

@injectable
class WatchDashboardSummaryUseCase {
  const WatchDashboardSummaryUseCase(this._repository);

  final DashboardRepository _repository;

  Stream<DashboardSummary> call(DateTime month) =>
      _repository.watchSummary(month);
}
