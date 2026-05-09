import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'workers_sheet_scaffold.dart';

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

class AdvanceForm extends StatefulWidget {
  const AdvanceForm({super.key, this.initialValue});
  final AdvanceFormResult? initialValue;
  @override
  State<AdvanceForm> createState() => _AdvanceFormState();
}

class _AdvanceFormState extends State<AdvanceForm> {
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
    return WorkersSheetScaffold(
      title: widget.initialValue == null ? l10n.addAdvance : l10n.editAdvance,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _dateNotifier,
              builder: (context, value, _) => OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDate: value,
                  );
                  if (picked != null) _dateNotifier.value = picked;
                },
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(DateFormat.yMd().format(value)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
              child: FilledButton(onPressed: _save, child: Text(l10n.save)),
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
