import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/worker_details_data.dart';
import '../bloc/worker_details_cubit.dart';
import 'month_selector.dart';

class WorkerDetailsHeader extends StatelessWidget {
  const WorkerDetailsHeader({
    super.key,
    required this.selectedMonth,
    required this.details,
    required this.currency,
  });

  final DateTime selectedMonth;
  final WorkerDetailsData details;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonthSelector(
            month: selectedMonth,
            onPrevious: context.read<WorkerDetailsCubit>().previousMonth,
            onNext: context.read<WorkerDetailsCubit>().nextMonth,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.registrationDate(
              DateFormat.yMd().format(details.worker.createdAt),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.currentRatePer100k(
              currency.format(details.summary.appliedRate),
            ),
          ),
        ],
      ),
    );
  }
}
