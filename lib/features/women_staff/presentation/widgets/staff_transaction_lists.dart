import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/staff_advance.dart';
import '../../domain/entities/staff_deduction.dart';
import '../bloc/staff_details_cubit.dart';

class AdvancesList extends StatelessWidget {
  const AdvancesList({
    super.key,
    required this.advances,
    required this.currency,
  });

  final List<StaffAdvance> advances;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<StaffDetailsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            l10n.advances,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: advances.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final item = advances[index];
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(AppSpacing.md),
                title: Text(currency.format(item.amount)),
                subtitle: Text(
                  '${DateFormat.yMd().format(item.date)}'
                  '${item.notes == null ? '' : '\n${item.notes}'}',
                ),
                trailing: item.carriedOver
                    ? Chip(label: Text(l10n.carryOver))
                    : IconButton(
                        onPressed: () => cubit.deleteAdvance(item.id),
                        icon: const Icon(Icons.delete_outline),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class DeductionsList extends StatelessWidget {
  const DeductionsList({
    super.key,
    required this.deductions,
    required this.currency,
  });

  final List<StaffDeduction> deductions;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<StaffDetailsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            l10n.deductions,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: deductions.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final item = deductions[index];
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(AppSpacing.md),
                title: Text(currency.format(item.amount)),
                subtitle: Text(
                  '${DateFormat.yMd().format(item.date)}'
                  '${item.notes == null ? '' : '\n${item.notes}'}',
                ),
                trailing: IconButton(
                  onPressed: () => cubit.deleteDeduction(item.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
