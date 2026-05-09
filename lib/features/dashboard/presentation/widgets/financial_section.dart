import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/financial_filter.dart';
import 'dashboard_card.dart';
import 'financial_filter_selector.dart';
import 'financial_table_card.dart';
import 'clients_annual_table.dart';
import 'threads_annual_table.dart';

class FinancialSection extends StatelessWidget {
  const FinancialSection({
    super.key,
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
    final financial = summary.financialSummary;
    if (financial == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(currentFilter: currentFilter, onFilterChanged: onFilterChanged),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            DashboardCard(
              title: l10n.totalDueFromClients,
              value: currency.format(financial.totalDueFromClients),
              icon: Icons.account_balance_wallet,
              color: const Color(0xFF10B981),
            ),
            DashboardCard(
              title: l10n.totalDueToSuppliers,
              value: currency.format(financial.totalDueToSuppliers),
              icon: Icons.shopping_cart,
              color: const Color(0xFFF59E0B),
            ),
            DashboardCard(
              title: l10n.totalMaintenanceCost,
              value: currency.format(financial.totalMaintenanceCost),
              icon: Icons.build_outlined,
              color: const Color(0xFF6366F1),
            ),
            DashboardCard(
              title: l10n.totalWorkerWagesYear,
              value: currency.format(financial.totalWorkerWagesYear),
              icon: Icons.people_outline,
              color: const Color(0xFF1F2937),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        FinancialTableCard(
          title: l10n.clientsAnnualTable,
          child: ClientsAnnualTable(
            summaries: financial.clientSummaries,
            currency: currency,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FinancialTableCard(
          title: l10n.threadsAnnualTable,
          child: ThreadsAnnualTable(
            summaries: financial.supplierSummaries,
            currency: currency,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.currentFilter, required this.onFilterChanged});

  final FinancialFilter currentFilter;
  final ValueChanged<FinancialFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final title = Text(
      l10n.financialOverview,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
    final filter = FinancialFilterSelector(
      current: currentFilter,
      onChanged: onFilterChanged,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [title, filter],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: title),
        const SizedBox(width: AppSpacing.md),
        filter,
      ],
    );
  }
}
