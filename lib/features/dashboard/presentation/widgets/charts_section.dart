import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'chart_card.dart';
import 'top_workers_chart.dart';
import 'thread_purchases_chart.dart';
import 'clients_pie_chart.dart';
import 'women_advances_chart.dart';

class ChartsSection extends StatelessWidget {
  const ChartsSection({
    super.key,
    required this.summary,
    required this.currency,
    required this.selectedMonth,
  });

  final DashboardSummary summary;
  final NumberFormat currency;
  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;
    final w = isDesktop ? 560.0 : double.infinity;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        ChartCard(
          width: w,
          title: l10n.dashboardTopWorkersChart,
          child: TopWorkersChart(points: summary.topWorkers),
        ),
        ChartCard(
          width: w,
          title: l10n.dashboardThreadsYearChart(selectedMonth.year.toString()),
          child: ThreadPurchasesChart(points: summary.threadPurchasesByMonth),
        ),
        ChartCard(
          width: w,
          title: l10n.dashboardClientsDistributionChart,
          child: ClientsPieChart(
            points: summary.clientOutstandingDistribution,
            currency: currency,
          ),
        ),
        ChartCard(
          width: w,
          title: l10n.dashboardWomenAdvancesChart,
          child: WomenAdvancesChart(points: summary.womenAdvancesByStaff),
        ),
      ],
    );
  }
}
