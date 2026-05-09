import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'dashboard_card.dart';

class DashboardCardsSection extends StatelessWidget {
  const DashboardCardsSection({
    super.key,
    required this.summary,
    required this.currency,
  });

  final DashboardSummary summary;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String fmt(double v) => currency.format(v).replaceAll('EGP', '').trim();

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        DashboardCard(
          title: l10n.dashboardSummaryWorkersWages,
          value: fmt(summary.totalWorkerWages),
          subtitle: l10n.workersAndAbsence(
            summary.registeredWorkersCount,
            summary.absentDaysCount,
          ),
          icon: Icons.attach_money,
          color: const Color(0xFF1F2937),
        ),
        DashboardCard(
          title: l10n.dashboardSummaryWomenWages,
          value: fmt(summary.totalWomenStaffWages),
          icon: Icons.attach_money,
          color: const Color(0xFF1F2937),
        ),
        DashboardCard(
          title: l10n.dashboardSummaryThreadPurchases,
          value: fmt(summary.totalThreadPurchases),
          subtitle: l10n.suppliersOutstanding(
            summary.suppliersWithOutstandingCount,
          ),
          icon: Icons.local_shipping_outlined,
          color: const Color(0xFF1F2937),
        ),
        DashboardCard(
          title: l10n.dashboardSummaryClientOutstanding,
          value: fmt(summary.totalClientOutstanding),
          subtitle: l10n.clientsDebts(summary.pendingClientBalancesCount),
          icon: Icons.work_outline,
          color: const Color(0xFFEF4444),
        ),
        DashboardCard(
          title: l10n.dashboardSummaryMaintenanceCost,
          value: fmt(summary.totalMaintenanceCost),
          icon: Icons.build_outlined,
          color: const Color(0xFF1F2937),
        ),
      ],
    );
  }
}
