import 'dart:developer';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../../clients/domain/usecases/get_client_balance_usecase.dart';

class DashboardClientQueries {
  const DashboardClientQueries(this._database, this._getClientBalanceUseCase);

  final AppDatabase _database;
  final GetClientBalanceUseCase _getClientBalanceUseCase;

  Future<
    (
      List<ClientAnnualSummary> summaries,
      List<DashboardPiePoint> piePoints,
      double totalDue,
    )
  >
  fetchClientData(({DateTime start, DateTime end}) range) async {
    final rows = await _database
        .customSelect(
          '''
      SELECT c.id, c.name,
        COALESCE(SUM(m.piece_count * m.price_per_piece), 0.0) as total_work,
        COALESCE((SELECT SUM(amount) FROM client_payments WHERE client_id = c.id AND payment_date BETWEEN ? AND ?), 0.0) as total_paid
      FROM clients c
      LEFT JOIN client_models m ON c.id = m.client_id AND m.date BETWEEN ? AND ?
      WHERE c.is_active = 1 GROUP BY c.id
      ORDER BY (total_work - total_paid) DESC
      ''',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
          ],
        )
        .get();

    double totalDue = 0;
    final summaries = <ClientAnnualSummary>[];
    final piePoints = <DashboardPiePoint>[];

    for (final row in rows) {
      final work = row.read<double?>('total_work') ?? 0.0;
      final paid = row.read<double?>('total_paid') ?? 0.0;
      final remaining = _getClientBalanceUseCase(
        totalAmount: work,
        totalPaid: paid,
      );

      if (remaining > 0) {
        totalDue += remaining;
        piePoints.add(
          DashboardPiePoint(
            label: row.read<String?>('name') ?? '',
            value: remaining,
          ),
        );
      }
      summaries.add(
        ClientAnnualSummary(
          clientId: row.read<int?>('id') ?? 0,
          name: row.read<String?>('name') ?? '',
          totalWork: work,
          totalPaid: paid,
          remaining: remaining,
        ),
      );
    }
    log('DEBUG: Dashboard: Total Due from Clients: $totalDue');
    return (summaries, piePoints, totalDue);
  }
}
