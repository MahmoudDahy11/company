import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'form_result_classes.dart';
import 'threads_sheet_scaffold.dart';

Future<SupplierFormResult?> showSupplierSheet(BuildContext context) {
  return showAdaptiveThreadsSheet<SupplierFormResult>(
    context: context,
    child: const _SupplierSheet(),
  );
}

class _SupplierSheet extends StatefulWidget {
  const _SupplierSheet();

  @override
  State<_SupplierSheet> createState() => _SupplierSheetState();
}

class _SupplierSheetState extends State<_SupplierSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ThreadsSheetScaffold(
      title: l10n.addSupplier,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.supplierName),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => InputValidator.required(context, v),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: l10n.phoneNumber),
              keyboardType: TextInputType.phone,
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
      Navigator.of(context).pop(
        SupplierFormResult(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        ),
      );
    }
  }
}
