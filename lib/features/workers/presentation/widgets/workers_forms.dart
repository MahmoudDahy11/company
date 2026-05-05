import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';

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

Future<AdvanceFormResult?> showAdvanceSheet(
  BuildContext context, {
  AdvanceFormResult? initialValue,
}) {
  return showAdaptiveWorkersSheet<AdvanceFormResult>(
    context: context,
    child: _AdvanceSheet(initialValue: initialValue),
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
    this.advanceId,
  });

  final DateTime date;
  final double amount;
  final String? notes;
  final int? advanceId;
}

class _WorkerNameSheet extends StatefulWidget {
  const _WorkerNameSheet();

  @override
  State<_WorkerNameSheet> createState() => _WorkerNameSheetState();
}

class _WorkerNameSheetState extends State<_WorkerNameSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SheetScaffold(
      title: l10n.addWorker,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(labelText: l10n.workerName),
              textInputAction: TextInputAction.done,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => InputValidator.required(context, v),
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: _save,
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }
}

class _StitchRateSheet extends StatefulWidget {
  const _StitchRateSheet();

  @override
  State<_StitchRateSheet> createState() => _StitchRateSheetState();
}

class _StitchRateSheetState extends State<_StitchRateSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SheetScaffold(
      title: l10n.updateStitchRate,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration:
                  InputDecoration(labelText: l10n.ratePer100kStitches),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: _save,
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(double.parse(_controller.text.trim()));
    }
  }
}

class _ProductionSheet extends StatefulWidget {
  const _ProductionSheet({this.initialValue});

  final ProductionFormResult? initialValue;

  @override
  State<_ProductionSheet> createState() => _ProductionSheetState();
}

class _ProductionSheetState extends State<_ProductionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _stitchesController;
  late final TextEditingController _notesController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    _stitchesController = TextEditingController(
      text: widget.initialValue?.stitchCount.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.initialValue?.notes ?? '',
    );
    _dateNotifier = ValueNotifier<DateTime>(
      widget.initialValue?.date ?? DateTime.now(),
    );
  }

  @override
  void dispose() {
    _stitchesController.dispose();
    _notesController.dispose();
    _dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SheetScaffold(
      title: widget.initialValue == null
          ? l10n.addProduction
          : l10n.editProduction,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _dateNotifier,
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
                      _dateNotifier.value = picked;
                    }
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(DateFormat.yMd().format(value)),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _stitchesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.stitchCount),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.notes),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: _save,
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        ProductionFormResult(
          productionId: widget.initialValue?.productionId,
          date: _dateNotifier.value,
          stitchCount: int.parse(_stitchesController.text.trim()),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }
}

class _AdvanceSheet extends StatefulWidget {
  const _AdvanceSheet({this.initialValue});

  final AdvanceFormResult? initialValue;

  @override
  State<_AdvanceSheet> createState() => _AdvanceSheetState();
}

class _AdvanceSheetState extends State<_AdvanceSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialValue?.amount.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.initialValue?.notes ?? '',
    );
    _dateNotifier = ValueNotifier<DateTime>(
      widget.initialValue?.date ?? DateTime.now(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SheetScaffold(
      title: widget.initialValue == null ? l10n.addAdvance : l10n.editAdvance,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _dateNotifier,
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
                      _dateNotifier.value = picked;
                    }
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(DateFormat.yMd().format(value)),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.amount),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.notes),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: _save,
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        AdvanceFormResult(
          advanceId: widget.initialValue?.advanceId,
          date: _dateNotifier.value,
          amount: double.parse(_amountController.text.trim()),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }
}

class _AbsentDaysSheet extends StatefulWidget {
  const _AbsentDaysSheet({required this.initialValue});

  final int initialValue;

  @override
  State<_AbsentDaysSheet> createState() => _AbsentDaysSheetState();
}

class _AbsentDaysSheetState extends State<_AbsentDaysSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SheetScaffold(
      title: l10n.absentDays,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.daysCount),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.range(context, v, min: 0, max: 31),
              ]),
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: _save,
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(int.parse(_controller.text.trim()));
    }
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
