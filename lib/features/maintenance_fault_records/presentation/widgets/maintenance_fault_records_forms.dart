import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';

class FaultRecordFormResult {
  const FaultRecordFormResult({
    this.id,
    required this.machineName,
    required this.faultName,
    required this.cost,
    required this.totalCost,
  });

  final int? id;
  final String machineName;
  final String faultName;
  final double cost;
  final double totalCost;
}

Future<FaultRecordFormResult?> showFaultRecordSheet(
  BuildContext context, {
  FaultRecordFormResult? initialValue,
}) {
  return showAdaptiveSheet<FaultRecordFormResult>(
    context: context,
    child: _FaultRecordSheet(initialValue: initialValue),
  );
}

Future<T?> showAdaptiveSheet<T>({
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

class _FaultRecordSheet extends StatefulWidget {
  const _FaultRecordSheet({this.initialValue});

  final FaultRecordFormResult? initialValue;

  @override
  State<_FaultRecordSheet> createState() => _FaultRecordSheetState();
}

class _FaultRecordSheetState extends State<_FaultRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _machineNameController;
  late final TextEditingController _faultNameController;
  late final TextEditingController _costController;
  late final TextEditingController _totalCostController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    _machineNameController = TextEditingController(
      text: widget.initialValue?.machineName ?? '',
    );
    _faultNameController = TextEditingController(
      text: widget.initialValue?.faultName ?? '',
    );
    _costController = TextEditingController(
      text: widget.initialValue?.cost.toString() ?? '',
    );
    _totalCostController = TextEditingController(
      text: widget.initialValue?.totalCost.toString() ?? '',
    );
    _dateNotifier = ValueNotifier<DateTime>(DateTime.now());
  }

  @override
  void dispose() {
    _machineNameController.dispose();
    _faultNameController.dispose();
    _costController.dispose();
    _totalCostController.dispose();
    _dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialValue != null;

    final l10n = AppLocalizations.of(context)!;

    return _SheetScaffold(
      title: isEditing ? l10n.editFaultRecord : l10n.addFaultRecord,
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
              controller: _machineNameController,
              decoration: InputDecoration(labelText: l10n.machineName),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => InputValidator.required(context, v),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _faultNameController,
              decoration: InputDecoration(labelText: l10n.faultName),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => InputValidator.required(context, v),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _costController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.cost),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
              onChanged: (_) => _syncTotalCost(),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _totalCostController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.totalCost),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(onPressed: _save, child: Text(l10n.save)),
            ),
          ],
        ),
      ),
    );
  }

  void _syncTotalCost() {
    if (_costController.text.isNotEmpty && _totalCostController.text.isEmpty) {
      _totalCostController.text = _costController.text;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        FaultRecordFormResult(
          id: widget.initialValue?.id,
          machineName: _machineNameController.text.trim(),
          faultName: _faultNameController.text.trim(),
          cost: double.parse(_costController.text.trim()),
          totalCost: double.parse(_totalCostController.text.trim()),
        ),
      );
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
