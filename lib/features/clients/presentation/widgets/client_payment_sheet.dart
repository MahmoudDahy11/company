import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'client_form_results.dart';
import 'clients_sheet_scaffold.dart';

Future<ClientPaymentFormResult?> showClientPaymentSheet(
  BuildContext context, {
  ClientPaymentFormResult? initialValue,
}) {
  return showAdaptiveClientsSheet<ClientPaymentFormResult>(
    context: context,
    child: _ClientPaymentSheet(initialValue: initialValue),
  );
}

class _ClientPaymentSheet extends StatefulWidget {
  const _ClientPaymentSheet({this.initialValue});
  final ClientPaymentFormResult? initialValue;

  @override
  State<_ClientPaymentSheet> createState() => _ClientPaymentSheetState();
}

class _ClientPaymentSheetState extends State<_ClientPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialValue?.amount.toString() ?? '');
    _notesController = TextEditingController(text: widget.initialValue?.notes ?? '');
    _dateNotifier = ValueNotifier<DateTime>(widget.initialValue?.paymentDate ?? DateTime.now());
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
    return ClientsSheetScaffold(
      title: widget.initialValue == null ? l10n.addPayment : l10n.editPayment,
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            textInputAction: TextInputAction.next,
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
            onFieldSubmitted: (_) => _save(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(onPressed: _save, child: Text(l10n.save)),
          ),
        ]),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(ClientPaymentFormResult(
        paymentId: widget.initialValue?.paymentId,
        amount: double.parse(_amountController.text.trim()),
        paymentDate: _dateNotifier.value,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      ));
    }
  }
}
