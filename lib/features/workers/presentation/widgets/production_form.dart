import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'workers_sheet_scaffold.dart';

class ProductionFormResult {
  const ProductionFormResult({
    required this.date,
    required this.stitchCount,
    this.notes,
    this.productionId,
  });
  final DateTime date;
  final int stitchCount;
  final String? notes;
  final int? productionId;
}

class ProductionForm extends StatefulWidget {
  const ProductionForm({super.key, this.initialValue});
  final ProductionFormResult? initialValue;
  @override
  State<ProductionForm> createState() => _ProductionFormState();
}

class _ProductionFormState extends State<ProductionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _stitchesController;
  late final TextEditingController _notesController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    _stitchesController = TextEditingController(
      text: widget.initialValue?.stitchCount.toString() ?? '',
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
    _stitchesController.dispose();
    _notesController.dispose();
    _dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return WorkersSheetScaffold(
      title: widget.initialValue == null
          ? l10n.addProduction
          : l10n.editProduction,
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
              controller: _stitchesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.stitchCount),
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
        ProductionFormResult(
          productionId: widget.initialValue?.productionId,
          date: _dateNotifier.value,
          stitchCount: int.parse(_stitchesController.text.trim()),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }
}
