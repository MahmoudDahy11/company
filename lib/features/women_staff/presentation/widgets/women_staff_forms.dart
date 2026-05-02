import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';

Future<T?> showAdaptiveStaffSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  if (MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop) {
    return showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: child,
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) => child,
  );
}

class StaffFormResult {
  const StaffFormResult({required this.name, required this.monthlySalary});

  final String name;
  final double monthlySalary;
}

class StaffAdvanceFormResult {
  const StaffAdvanceFormResult({
    required this.amount,
    required this.date,
    this.notes,
  });

  final double amount;
  final DateTime date;
  final String? notes;
}

Future<StaffFormResult?> showAddStaffSheet(BuildContext context) {
  return showAdaptiveStaffSheet<StaffFormResult>(
    context: context,
    child: const _AddStaffSheet(),
  );
}

Future<double?> showUpdateSalarySheet(
  BuildContext context, {
  required double initialValue,
}) {
  return showAdaptiveStaffSheet<double>(
    context: context,
    child: _UpdateSalarySheet(initialValue: initialValue),
  );
}

Future<StaffAdvanceFormResult?> showStaffAdvanceSheet(BuildContext context) {
  return showAdaptiveStaffSheet<StaffAdvanceFormResult>(
    context: context,
    child: const _AddAdvanceSheet(),
  );
}

class _AddStaffSheet extends StatelessWidget {
  const _AddStaffSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final salaryController = TextEditingController();

    return _StaffSheetScaffold(
      title: l10n.addStaff,
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: l10n.staffName),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: salaryController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.monthlySalary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final salary = double.tryParse(salaryController.text.trim());
                if (nameController.text.trim().isNotEmpty && salary != null) {
                  Navigator.of(context).pop(
                    StaffFormResult(
                      name: nameController.text.trim(),
                      monthlySalary: salary,
                    ),
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateSalarySheet extends StatelessWidget {
  const _UpdateSalarySheet({required this.initialValue});

  final double initialValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: initialValue.toStringAsFixed(2),
    );

    return _StaffSheetScaffold(
      title: l10n.updateSalary,
      child: Column(
        children: [
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.monthlySalary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final salary = double.tryParse(controller.text.trim());
                if (salary != null) {
                  Navigator.of(context).pop(salary);
                }
              },
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddAdvanceSheet extends StatelessWidget {
  const _AddAdvanceSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    final dateNotifier = ValueNotifier<DateTime>(DateTime.now());

    return _StaffSheetScaffold(
      title: l10n.addAdvance,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: dateNotifier,
            builder: (context, value, _) {
              return OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDate: value,
                  );
                  if (picked != null) {
                    dateNotifier.value = picked;
                  }
                },
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(DateFormat.yMd().format(value)),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.amount),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: notesController,
            decoration: InputDecoration(labelText: l10n.notes),
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                if (amount != null) {
                  Navigator.of(context).pop(
                    StaffAdvanceFormResult(
                      amount: amount,
                      date: dateNotifier.value,
                      notes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                    ),
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffSheetScaffold extends StatelessWidget {
  const _StaffSheetScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
