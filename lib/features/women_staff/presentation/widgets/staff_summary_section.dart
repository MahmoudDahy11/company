import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/staff_month_summary.dart';

class StaffSummarySection extends StatelessWidget {
  const StaffSummarySection({
    super.key,
    required this.summary,
    required this.currency,
  });

  final StaffMonthSummary summary;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        _SummaryCard(
          label: l10n.fixedSalary,
          value: currency.format(summary.monthlySalary),
        ),
        _SummaryCard(
          label: l10n.advances,
          value: currency.format(summary.totalAdvances),
        ),
        _SummaryCard(
          label: l10n.deductions,
          value: currency.format(summary.totalDeductions),
        ),
        _SummaryCard(
          label: l10n.carryOver,
          value: currency.format(summary.carryOver),
        ),
        _SummaryCard(
          label: l10n.netSalary,
          value: currency.format(summary.netSalary),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const SizedBox(height: AppSpacing.sm),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
