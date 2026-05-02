import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const String routeName = 'dashboard';
  static const String routePath = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<DashboardCubit>()..start(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final summary = state.summary;
        final currency = NumberFormat.currency(
          locale: Localizations.localeOf(context).toLanguageTag(),
          symbol: 'EGP ',
          decimalDigits: 2,
        );

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dashboard,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                MonthSelector(
                  month: state.selectedMonth,
                  onPrevious: context.read<DashboardCubit>().previousMonth,
                  onNext: context.read<DashboardCubit>().nextMonth,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (summary == null)
                  Center(
                    child: Text(state.errorMessage ?? l10n.failedToLoadData),
                  )
                else ...[
                  _SummarySection(summary: summary, currency: currency),
                  const SizedBox(height: AppSpacing.lg),
                  _QuickInfoSection(summary: summary),
                  const SizedBox(height: AppSpacing.lg),
                  _ChartsSection(summary: summary, currency: currency),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.summary, required this.currency});

  final DashboardSummary summary;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cards = [
      (
        l10n.dashboardSummaryWorkersWages,
        currency.format(summary.totalWorkerWages),
      ),
      (
        l10n.dashboardSummaryWomenWages,
        currency.format(summary.totalWomenStaffWages),
      ),
      (
        l10n.dashboardSummaryThreadPurchases,
        currency.format(summary.totalThreadPurchases),
      ),
      (
        l10n.dashboardSummaryClientOutstanding,
        currency.format(summary.totalClientOutstanding),
      ),
    ];

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: cards
          .map(
            (card) => SizedBox(
              width: MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop
                  ? 280
                  : double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.$1),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        card.$2,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuickInfoSection extends StatelessWidget {
  const _QuickInfoSection({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      (
        l10n.dashboardRegisteredWorkers,
        summary.registeredWorkersCount.toString(),
      ),
      (l10n.dashboardAbsentDaysThisMonth, summary.absentDaysCount.toString()),
      (
        l10n.dashboardPendingClients,
        summary.pendingClientBalancesCount.toString(),
      ),
      (
        l10n.dashboardSuppliersOutstanding,
        summary.suppliersWithOutstandingCount.toString(),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardQuickInfoTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: items
                  .map(
                    (item) => Container(
                      constraints: const BoxConstraints(minWidth: 180),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.$1),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            item.$2,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({required this.summary, required this.currency});

  final DashboardSummary summary;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        _ChartCard(
          width: isDesktop ? 560 : double.infinity,
          title: l10n.dashboardTopWorkersChart,
          child: _TopWorkersChart(points: summary.topWorkers),
        ),
        _ChartCard(
          width: isDesktop ? 560 : double.infinity,
          title: l10n.dashboardThreadsYearChart,
          child: _ThreadPurchasesLineChart(
            points: summary.threadPurchasesByMonth,
          ),
        ),
        _ChartCard(
          width: isDesktop ? 560 : double.infinity,
          title: l10n.dashboardClientsDistributionChart,
          child: _ClientsPieChart(
            points: summary.clientOutstandingDistribution,
            currency: currency,
          ),
        ),
        _ChartCard(
          width: isDesktop ? 560 : double.infinity,
          title: l10n.dashboardWomenAdvancesChart,
          child: _WomenAdvancesChart(points: summary.womenAdvancesByStaff),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.width,
    required this.title,
    required this.child,
  });

  final double width;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              SizedBox(height: 260, child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopWorkersChart extends StatelessWidget {
  const _TopWorkersChart({required this.points});

  final List<DashboardBarPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noData));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 44),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    points[index].label,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < points.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: points[i].value,
                  width: 24,
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF0F766E),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ThreadPurchasesLineChart extends StatelessWidget {
  const _ThreadPurchasesLineChart({required this.points});

  final List<DashboardLinePoint> points;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 44),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: points
                .map((point) => FlSpot(point.month.toDouble(), point.value))
                .toList(),
            isCurved: true,
            barWidth: 3,
            color: const Color(0xFFEA580C),
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

class _ClientsPieChart extends StatelessWidget {
  const _ClientsPieChart({required this.points, required this.currency});

  final List<DashboardPiePoint> points;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noCurrentDebts));
    }

    final colors = <Color>[
      const Color(0xFF0F766E),
      const Color(0xFFEA580C),
      const Color(0xFF2563EB),
      const Color(0xFFDC2626),
      const Color(0xFF059669),
      const Color(0xFFD97706),
    ];

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 34,
              sections: [
                for (var i = 0; i < points.length; i++)
                  PieChartSectionData(
                    color: colors[i % colors.length],
                    value: points[i].value,
                    title: '',
                    radius: 70,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: ListView(
            children: [
              for (var i = 0; i < points.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(points[i].label)),
                      const SizedBox(width: AppSpacing.sm),
                      Text(currency.format(points[i].value)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WomenAdvancesChart extends StatelessWidget {
  const _WomenAdvancesChart({required this.points});

  final List<DashboardBarPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noData));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 44),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    points[index].label,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < points.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: points[i].value,
                  width: 24,
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFDB2777),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
