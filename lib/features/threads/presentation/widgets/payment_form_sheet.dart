import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'form_result_classes.dart';
import 'shared_form_widgets.dart';
import 'threads_sheet_scaffold.dart';

Future<SupplierPaymentFormResult?> showSupplierPaymentSheet(
  BuildContext context, {
  SupplierPaymentFormResult? initialValue,
}) {
  return showAdaptiveThreadsSheet<SupplierPaymentFormResult>(
    context: context,
    child: _SupplierPaymentSheet(initialValue: initialValue),
  );
}

class _SupplierPaymentSheet extends StatefulWidget {
  const _SupplierPaymentSheet({this.initialValue});

  final SupplierPaymentFormResult? initialValue;

  @override
  State<_SupplierPaymentSheet> createState() => _SupplierPaymentSheetState();
}

class _SupplierPaymentSheetState extends State<_SupplierPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    final v = widget.initialValue;
    _amountController = TextEditingController(text: v?.amount.toString() ?? '');
    _notesController = TextEditingController(text: v?.notes ?? '');
    _dateNotifier = ValueNotifier<DateTime>(v?.paymentDate ?? DateTime.now());
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
    final isEditing = widget.initialValue != null;

    return ThreadsSheetScaffold(
      title: isEditing ? l10n.editPayment : l10n.addPayment,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateButton(dateNotifier: _dateNotifier),
            const SizedBox(height: AppSpacing.md),
            FormTextField(
              controller: _amountController,
              label: l10n.amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),
            FormTextField(
              controller: _notesController,
              label: l10n.notes,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
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
        SupplierPaymentFormResult(
          paymentId: widget.initialValue?.paymentId,
          amount: double.parse(_amountController.text.trim()),
          paymentDate: _dateNotifier.value,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }
}
