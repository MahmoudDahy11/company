import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'women_staff_forms.dart';

Future<double?> showUpdateSalarySheet(
  BuildContext context, {
  required double initialValue,
}) {
  return showAdaptiveStaffSheet<double>(
    context: context,
    child: _UpdateSalaryForm(initialValue: initialValue),
  );
}

class _UpdateSalaryForm extends StatefulWidget {
  const _UpdateSalaryForm({required this.initialValue});

  final double initialValue;

  @override
  State<_UpdateSalaryForm> createState() => _UpdateSalaryFormState();
}

class _UpdateSalaryFormState extends State<_UpdateSalaryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StaffSheetScaffold(
      title: l10n.updateSalary,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.monthlySalary),
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
              child: FilledButton(onPressed: _save, child: Text(l10n.save)),
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
