import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'workers_sheet_scaffold.dart';

class StitchRateForm extends StatefulWidget {
  const StitchRateForm({super.key});

  @override
  State<StitchRateForm> createState() => _StitchRateFormState();
}

class _StitchRateFormState extends State<StitchRateForm> {
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
    return WorkersSheetScaffold(
      title: l10n.updateStitchRate,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.ratePer100kStitches),
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
