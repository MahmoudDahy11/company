import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../clients/presentation/pages/client_details_page.dart';
import '../../../threads/presentation/pages/supplier_details_page.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/financial_filter.dart';
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
          child: RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().start(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                                      ? Theme.of(
                                          context,
                                        ).textTheme.headlineSmall
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
                    _DashboardCardsSection(
                      summary: summary,
                      currency: currency,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ChartsSection(
                      summary: summary,
                      currency: currency,
                      selectedMonth: state.selectedMonth,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Divider(),
                    const SizedBox(height: AppSpacing.xl),
                    _FinancialSection(
                      summary: summary,
                      currency: currency,
                      currentFilter: state.financialFilter,
                      onFilterChanged: context
                          .read<DashboardCubit>()
                          .updateFinancialFilter,
                    ),
                  ],
                ],
              ),
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
        _DashboardCard(
          title: l10n.dashboardSummaryMaintenanceCost,
          value: currency
              .format(summary.totalMaintenanceCost)
              .replaceAll('EGP', '')
              .trim(),
          subtitle: null,
          icon: Icons.build_outlined,
          color: const Color(0xFF1F2937),
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

class _FinancialSection extends StatelessWidget {
  const _FinancialSection({
    required this.summary,
    required this.currency,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  final DashboardSummary summary;
  final NumberFormat currency;
  final FinancialFilter currentFilter;
  final ValueChanged<FinancialFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final financial = summary.financialSummary;

    if (financial == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            if (isMobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  Text(
                    l10n.financialOverview,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  _FinancialFilterSelector(
                    current: currentFilter,
                    onChanged: onFilterChanged,
                  ),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.financialOverview,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _FinancialFilterSelector(
                  current: currentFilter,
                  onChanged: onFilterChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            _DashboardCard(
              title: l10n.totalDueFromClients,
              value: currency.format(financial.totalDueFromClients),
              icon: Icons.account_balance_wallet,
              color: const Color(0xFF10B981), // Green
            ),
            _DashboardCard(
              title: l10n.totalDueToSuppliers,
              value: currency.format(financial.totalDueToSuppliers),
              icon: Icons.shopping_cart,
              color: const Color(0xFFF59E0B), // Orange/Amber
            ),
            _DashboardCard(
              title: l10n.totalMaintenanceCost,
              value: currency.format(financial.totalMaintenanceCost),
              icon: Icons.build_outlined,
              color: const Color(0xFF6366F1), // Indigo
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _FinancialTableCard(
          title: l10n.clientsAnnualTable,
          child: _ClientsAnnualTable(
            summaries: financial.clientSummaries,
            currency: currency,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _FinancialTableCard(
          title: l10n.threadsAnnualTable,
          child: _ThreadsAnnualTable(
            summaries: financial.supplierSummaries,
            currency: currency,
          ),
        ),
      ],
    );
  }
}

class _FinancialFilterSelector extends StatelessWidget {
  const _FinancialFilterSelector({
    required this.current,
    required this.onChanged,
  });

  final FinancialFilter current;
  final ValueChanged<FinancialFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<FinancialFilter>(
      segments: [
        ButtonSegment(
          value: FinancialFilter.last3Months,
          label: Text(l10n.last3Months),
        ),
        ButtonSegment(
          value: FinancialFilter.last6Months,
          label: Text(l10n.last6Months),
        ),
        ButtonSegment(
          value: FinancialFilter.lastYear,
          label: Text(l10n.lastYear),
        ),
      ],
      selected: {current},
      onSelectionChanged: (set) => onChanged(set.first),
    );
  }
}

class _FinancialTableCard extends StatelessWidget {
  const _FinancialTableCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
    );
  }
}

class _ClientsAnnualTable extends StatelessWidget {
  const _ClientsAnnualTable({required this.summaries, required this.currency});

  final List<ClientAnnualSummary> summaries;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text(l10n.clientName)),
              DataColumn(label: Text(l10n.totalWork), numeric: true),
              DataColumn(label: Text(l10n.totalPaidHeader), numeric: true),
              DataColumn(label: Text(l10n.remaining), numeric: true),
            ],
            rows: summaries.map((s) {
              final isDimmed = s.remaining <= 0;
              final style = isDimmed
                  ? const TextStyle(color: Colors.grey)
                  : const TextStyle(fontWeight: FontWeight.bold);

              return DataRow(
                onSelectChanged: (_) {
                  context.goNamed(
                    ClientDetailsPage.routeName,
                    pathParameters: {'clientId': s.clientId.toString()},
                  );
                },
                cells: [
                  DataCell(Text(s.name, style: style)),
                  DataCell(Text(currency.format(s.totalWork), style: style)),
                  DataCell(Text(currency.format(s.totalPaid), style: style)),
                  DataCell(
                    Text(
                      currency.format(s.remaining),
                      style: style.copyWith(
                        color: s.remaining > 0 ? Colors.red : null,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 60),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= summaries.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          summaries[i].name,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: summaries.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.totalPaid,
                      color: Colors.green,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: e.value.remaining,
                      color: Colors.red,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ThreadsAnnualTable extends StatelessWidget {
  const _ThreadsAnnualTable({required this.summaries, required this.currency});

  final List<SupplierAnnualSummary> summaries;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text(l10n.supplierName)),
              DataColumn(label: Text(l10n.totalPurchasesHeader), numeric: true),
              DataColumn(label: Text(l10n.totalPaidHeader), numeric: true),
              DataColumn(label: Text(l10n.remainingOur), numeric: true),
            ],
            rows: summaries.map((s) {
              return DataRow(
                onSelectChanged: (_) {
                  context.goNamed(
                    SupplierDetailsPage.routeName,
                    pathParameters: {'supplierId': s.supplierId.toString()},
                  );
                },
                cells: [
                  DataCell(Text(s.name)),
                  DataCell(Text(currency.format(s.totalPurchases))),
                  DataCell(Text(currency.format(s.totalPaid))),
                  DataCell(
                    Text(
                      currency.format(s.remaining),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 60),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= summaries.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          summaries[i].name,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: summaries.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.totalPaid,
                      color: Colors.green,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: e.value.remaining,
                      color: Colors.orange,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
