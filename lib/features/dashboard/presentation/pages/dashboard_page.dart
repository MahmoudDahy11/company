import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
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
                Builder(
                  builder: (context) {
                    final isMobile =
                        MediaQuery.sizeOf(context).width <
                        AppBreakpoints.mobile;
                    final headerContent = [
                      _DashboardMonthSelector(
                        month: state.selectedMonth,
                        onChanged: context.read<DashboardCubit>().updateMonth,
                      ),
                      if (isMobile) const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.dashboard,
                        style:
                            (isMobile
                                    ? Theme.of(context).textTheme.headlineSmall
                                    : Theme.of(
                                        context,
                                      ).textTheme.headlineMedium)
                                ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ];

                    if (isMobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: headerContent,
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: headerContent,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (summary == null)
                  Center(
                    child: Text(state.errorMessage ?? l10n.failedToLoadData),
                  )
                else ...[
                  _DashboardCardsSection(summary: summary, currency: currency),
                  const SizedBox(height: AppSpacing.lg),
                  _ChartsSection(
                    summary: summary,
                    currency: currency,
                    selectedMonth: state.selectedMonth,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardCardsSection extends StatelessWidget {
  const _DashboardCardsSection({required this.summary, required this.currency});

  final DashboardSummary summary;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        _DashboardCard(
          title: l10n.dashboardSummaryWorkersWages,
          value: currency
              .format(summary.totalWorkerWages)
              .replaceAll('EGP', '')
              .trim(),
          subtitle: l10n.workersAndAbsence(
            summary.registeredWorkersCount,
            summary.absentDaysCount,
          ),
          icon: Icons.attach_money,
          color: const Color(0xFF1F2937),
        ),
        _DashboardCard(
          title: l10n.dashboardSummaryWomenWages,
          value: currency
              .format(summary.totalWomenStaffWages)
              .replaceAll('EGP', '')
              .trim(),
          subtitle: null,
          icon: Icons.attach_money,
          color: const Color(0xFF1F2937),
        ),
        _DashboardCard(
          title: l10n.dashboardSummaryThreadPurchases,
          value: currency
              .format(summary.totalThreadPurchases)
              .replaceAll('EGP', '')
              .trim(),
          subtitle: l10n.suppliersOutstanding(
            summary.suppliersWithOutstandingCount,
          ),
          icon: Icons.local_shipping_outlined,
          color: const Color(0xFF1F2937),
        ),
        _DashboardCard(
          title: l10n.dashboardSummaryClientOutstanding,
          value: currency
              .format(summary.totalClientOutstanding)
              .replaceAll('EGP', '')
              .trim(),
          subtitle: l10n.clientsDebts(summary.pendingClientBalancesCount),
          icon: Icons.work_outline,
          color: const Color(0xFFEF4444), // Red for debts
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop
          ? (MediaQuery.sizeOf(context).width - 64 - 16) /
                2 // Accounts for padding
          : double.infinity,
      constraints: const BoxConstraints(maxWidth: 500, minHeight: 140),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(icon, color: color, size: 28),
        ],
      ),
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({
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
          title: l10n.dashboardThreadsYearChart(selectedMonth.year.toString()),
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

class _DashboardMonthSelector extends StatelessWidget {
  const _DashboardMonthSelector({required this.month, required this.onChanged});

  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    final months = List.generate(12, (index) {
      final m = DateTime(month.year, index + 1);
      return DropdownMenuItem(
        value: index + 1,
        child: Text(DateFormat.MMMM(locale).format(m)),
      );
    });

    final years = List.generate(10, (index) {
      final y = DateTime.now().year - 5 + index;
      return DropdownMenuItem(value: y, child: Text(y.toString()));
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: month.year,
              items: years,
              onChanged: (y) {
                if (y != null) {
                  onChanged(DateTime(y, month.month));
                }
              },
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: month.month,
              items: months,
              onChanged: (m) {
                if (m != null) {
                  onChanged(DateTime(month.year, m));
                }
              },
            ),
          ),
        ),
      ],
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
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
            left: BorderSide(color: Colors.grey.shade400),
          ),
        ),
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
                  width: 50,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  color: const Color(0xFF374151), // Dark grey like screenshot
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
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
            left: BorderSide(color: Colors.grey.shade400),
          ),
        ),
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
            barWidth: 2,
            color: const Color(0xFFF97316), // Orange
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: const Color(0xFFF97316),
                  ),
            ),
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
