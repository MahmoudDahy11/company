import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'women_staff_forms.dart';

Future<StaffAdvanceFormResult?> showStaffAdvanceSheet(BuildContext context) {
  return showAdaptiveStaffSheet<StaffAdvanceFormResult>(
    context: context,
    child: _AdvanceDeductionForm(title: AppLocalizations.of(context)!.addAdvance),
  );
}

Future<StaffAdvanceFormResult?> showStaffDeductionSheet(BuildContext context) {
  return showAdaptiveStaffSheet<StaffAdvanceFormResult>(
    context: context,
    child: _AdvanceDeductionForm(title: AppLocalizations.of(context)!.addDeduction),
  );
}

class _AdvanceDeductionForm extends StatefulWidget {
  const _AdvanceDeductionForm({required this.title});
  final String title;

  @override
  State<_AdvanceDeductionForm> createState() => _AdvanceDeductionFormState();
}

class _AdvanceDeductionFormState extends State<_AdvanceDeductionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateNotifier = ValueNotifier<DateTime>(DateTime.now());

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
    return StaffSheetScaffold(
      title: widget.title,
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
                      context: context, firstDate: DateTime(2020),
                      lastDate: DateTime(2100), initialDate: value,
                    );
                    if (picked != null) _dateNotifier.value = picked;
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(DateFormat.yMd().format(value)),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
      Navigator.of(context).pop(StaffAdvanceFormResult(
        amount: double.parse(_amountController.text.trim()),
        date: _dateNotifier.value,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      ));
    }
  }
}
