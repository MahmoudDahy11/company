import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/staff_details_cubit.dart';
import 'advance_deduction_form.dart';
import 'update_salary_form.dart';

class StaffDetailActions extends StatelessWidget {
  const StaffDetailActions({super.key, required this.currentSalary});

  final double currentSalary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<StaffDetailsCubit>();

    return Row(
      children: [
        FilledButton.icon(
          onPressed: () async {
            final salary = await showUpdateSalarySheet(
              context,
              initialValue: currentSalary,
            );
            if (salary != null && context.mounted) {
              await cubit.updateSalary(salary);
            }
          },
          icon: const Icon(Icons.edit_outlined),
          label: Text(l10n.updateSalary),
        ),
        const SizedBox(width: AppSpacing.sm),
        FilledButton.icon(
          onPressed: () async {
            final result = await showStaffAdvanceSheet(context);
            if (result != null && context.mounted) {
              await cubit.addAdvance(
                amount: result.amount,
                date: result.date,
                notes: result.notes,
              );
            }
          },
          icon: const Icon(Icons.add),
          label: Text(l10n.addAdvance),
        ),
        const SizedBox(width: AppSpacing.sm),
        FilledButton.icon(
          onPressed: () async {
            final result = await showStaffDeductionSheet(context);
            if (result != null && context.mounted) {
              await cubit.addDeduction(
                amount: result.amount,
                date: result.date,
                notes: result.notes,
              );
            }
          },
          icon: const Icon(Icons.remove_circle_outline),
          label: Text(l10n.addDeduction),
        ),
      ],
    );
  }
}
