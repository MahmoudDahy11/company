import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../domain/entities/staff_list_item.dart';
import '../bloc/women_staff_cubit.dart';
import 'advance_deduction_form.dart';

class StaffTableRowActions extends StatelessWidget {
  const StaffTableRowActions({super.key, required this.item});

  final StaffListItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<WomenStaffCubit>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async {
            final result = await showStaffAdvanceSheet(context);
            if (result != null && context.mounted) {
              await cubit.addAdvance(
                staffId: item.id,
                amount: result.amount,
                date: result.date,
                notes: result.notes,
              );
            }
          },
          icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
          tooltip: l10n.addAdvance,
        ),
        IconButton(
          onPressed: () async {
            final result = await showStaffDeductionSheet(context);
            if (result != null && context.mounted) {
              await cubit.addDeduction(
                staffId: item.id,
                amount: result.amount,
                date: result.date,
                notes: result.notes,
              );
            }
          },
          icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
          tooltip: l10n.addDeduction,
        ),
        IconButton(
          onPressed: () => context.pushNamed(
            'staff-details',
            pathParameters: {'staffId': item.id.toString()},
          ),
          icon: const Icon(Icons.visibility_outlined, color: Colors.blue),
          tooltip: l10n.details,
        ),
        IconButton(
          onPressed: () => _confirmDelete(context),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          tooltip: l10n.delete,
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteStaffTitle),
        content: Text(l10n.confirmDeleteStaff(item.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<WomenStaffCubit>().deleteStaff(item.id);
    }
  }
}
