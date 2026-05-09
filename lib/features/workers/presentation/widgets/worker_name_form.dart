import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'workers_sheet_scaffold.dart';

class WorkerNameForm extends StatefulWidget {
  const WorkerNameForm({super.key});

  @override
  State<WorkerNameForm> createState() => _WorkerNameFormState();
}

class _WorkerNameFormState extends State<WorkerNameForm> {
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
              child: FilledButton(onPressed: _save, child: Text(l10n.save)),
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
