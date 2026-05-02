import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';

Future<T?> showAdaptiveWorkersSheet<T>({
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

Future<String?> showWorkerNameSheet(BuildContext context) {
  return showAdaptiveWorkersSheet<String>(
    context: context,
    child: const _WorkerNameSheet(),
  );
}

Future<double?> showStitchRateSheet(BuildContext context) {
  return showAdaptiveWorkersSheet<double>(
    context: context,
    child: const _StitchRateSheet(),
  );
}

Future<ProductionFormResult?> showProductionSheet(
  BuildContext context, {
  ProductionFormResult? initialValue,
}) {
  return showAdaptiveWorkersSheet<ProductionFormResult>(
    context: context,
    child: _ProductionSheet(initialValue: initialValue),
  );
}

Future<AdvanceFormResult?> showAdvanceSheet(BuildContext context) {
  return showAdaptiveWorkersSheet<AdvanceFormResult>(
    context: context,
    child: const _AdvanceSheet(),
  );
}

Future<int?> showAbsentDaysSheet(
  BuildContext context, {
  required int initialValue,
}) {
  return showAdaptiveWorkersSheet<int>(
    context: context,
    child: _AbsentDaysSheet(initialValue: initialValue),
  );
}

class ProductionFormResult {
  const ProductionFormResult({
    required this.date,
    required this.stitchCount,
    this.notes,
    this.productionId,
  });

  final DateTime date;
  final int stitchCount;
  final String? notes;
  final int? productionId;
}

class AdvanceFormResult {
  const AdvanceFormResult({
    required this.date,
    required this.amount,
    this.notes,
  });

  final DateTime date;
  final double amount;
  final String? notes;
}

class _WorkerNameSheet extends StatelessWidget {
  const _WorkerNameSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    return _SheetScaffold(
      title: l10n.addWorker,
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: l10n.workerName),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(controller.text.trim());
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

class _StitchRateSheet extends StatelessWidget {
  const _StitchRateSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    return _SheetScaffold(
      title: l10n.updateStitchRate,
      child: Column(
        children: [
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.ratePer100kStitches),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final parsed = double.tryParse(controller.text.trim());
                if (parsed != null) {
                  Navigator.of(context).pop(parsed);
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

class _ProductionSheet extends StatelessWidget {
  const _ProductionSheet({this.initialValue});

  final ProductionFormResult? initialValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateNotifier = ValueNotifier<DateTime>(
      initialValue?.date ?? DateTime.now(),
    );
    final stitchesController = TextEditingController(
      text: initialValue?.stitchCount.toString() ?? '',
    );
    final notesController = TextEditingController(
      text: initialValue?.notes ?? '',
    );

    return _SheetScaffold(
      title: initialValue == null ? l10n.addProduction : l10n.editProduction,
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
            controller: stitchesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.stitchCount),
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
                final stitchCount = int.tryParse(
                  stitchesController.text.trim(),
                );
                if (stitchCount != null) {
                  Navigator.of(context).pop(
                    ProductionFormResult(
                      productionId: initialValue?.productionId,
                      date: dateNotifier.value,
                      stitchCount: stitchCount,
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

class _AdvanceSheet extends StatelessWidget {
  const _AdvanceSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateNotifier = ValueNotifier<DateTime>(DateTime.now());
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    return _SheetScaffold(
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
                    AdvanceFormResult(
                      date: dateNotifier.value,
                      amount: amount,
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

class _AbsentDaysSheet extends StatelessWidget {
  const _AbsentDaysSheet({required this.initialValue});

  final int initialValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: initialValue.toString());

    return _SheetScaffold(
      title: l10n.absentDays,
      child: Column(
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.daysCount),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());
                if (value != null) {
                  Navigator.of(context).pop(value);
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

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({required this.title, required this.child});

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
