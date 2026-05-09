import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'workers_sheet_scaffold.dart';

class AbsentDaysForm extends StatefulWidget {
  const AbsentDaysForm({super.key, required this.initialValue});

  final int initialValue;

  @override
  State<AbsentDaysForm> createState() => _AbsentDaysFormState();
}

class _AbsentDaysFormState extends State<AbsentDaysForm> {
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
    return WorkersSheetScaffold(
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
              child: FilledButton(onPressed: _save, child: Text(l10n.save)),
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
