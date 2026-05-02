import 'package:injectable/injectable.dart';

import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_data_source.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._localDataSource);

  final DashboardLocalDataSource _localDataSource;

  @override
  Stream<DashboardSummary> watchSummary(DateTime month) {
    return _localDataSource.watchSummary(month);
  }
}
