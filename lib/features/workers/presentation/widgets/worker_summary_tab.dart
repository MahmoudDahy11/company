import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/worker_details_cubit.dart';
import '../bloc/worker_details_state.dart';

class WorkerSummaryTab extends StatelessWidget {
  const WorkerSummaryTab({super.key, required this.state, required this.currency});

  final WorkerDetailsState state;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summary = state.details!.summary;
    final items = <({String label, String value})>[
      (label: l10n.totalStitches, value: NumberFormat.decimalPattern().format(summary.totalStitchCount)),
      (label: l10n.earnings, value: currency.format(summary.totalEarnings)),
      (label: l10n.advances, value: currency.format(summary.totalAdvances)),
      (label: l10n.carryOver, value: currency.format(summary.carryOver)),
      (label: l10n.absentDays, value: summary.absentDays.toString()),
      (label: l10n.netSalary, value: currency.format(summary.netSalary)),
    ];

    return RefreshIndicator(
      onRefresh: () => context.read<WorkerDetailsCubit>().refresh(),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 260, mainAxisExtent: 120,
          crossAxisSpacing: AppSpacing.md, mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.label),
                  const SizedBox(height: AppSpacing.sm),
                  Text(item.value, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
