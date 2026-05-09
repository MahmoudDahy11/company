import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'client_form_results.dart';
import 'clients_sheet_scaffold.dart';

Future<ClientModelFormResult?> showClientModelSheet(
  BuildContext context, {
  ClientModelFormResult? initialValue,
}) {
  return showAdaptiveClientsSheet<ClientModelFormResult>(
    context: context,
    child: _ClientModelSheet(initialValue: initialValue),
  );
}

class _ClientModelSheet extends StatefulWidget {
  const _ClientModelSheet({this.initialValue});
  final ClientModelFormResult? initialValue;

  @override
  State<_ClientModelSheet> createState() => _ClientModelSheetState();
}

class _ClientModelSheetState extends State<_ClientModelSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _modelController;
  late final TextEditingController _piecesController;
  late final TextEditingController _priceController;
  late final TextEditingController _notesController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(
      text: widget.initialValue?.modelName ?? '',
    );
    _piecesController = TextEditingController(
      text: widget.initialValue?.pieceCount.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.initialValue?.pricePerPiece.toString() ?? '',
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
    _modelController.dispose();
    _piecesController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String? req(v) => InputValidator.required(context, v);
    String? positive(v) => InputValidator.positiveNumber(context, v);
    return ClientsSheetScaffold(
      title: widget.initialValue == null ? l10n.addModel : l10n.editModel,
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
              controller: _modelController,
              decoration: InputDecoration(labelText: l10n.modelName),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: req,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _piecesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.pieceCount),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([req, positive]),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.pricePerPiece),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([req, positive]),
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
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        ClientModelFormResult(
          modelId: widget.initialValue?.modelId,
          modelName: _modelController.text.trim(),
          pieceCount: int.parse(_piecesController.text.trim()),
          pricePerPiece: double.parse(_priceController.text.trim()),
          date: _dateNotifier.value,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }
}
