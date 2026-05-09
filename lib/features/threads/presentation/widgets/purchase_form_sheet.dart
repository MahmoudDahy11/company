import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import 'form_result_classes.dart';
import 'shared_form_widgets.dart';
import 'threads_sheet_scaffold.dart';

Future<PurchaseFormResult?> showPurchaseSheet(
  BuildContext context, {
  PurchaseFormResult? initialValue,
}) {
  return showAdaptiveThreadsSheet<PurchaseFormResult>(
    context: context,
    child: _PurchaseSheet(initialValue: initialValue),
  );
}

class _PurchaseSheet extends StatefulWidget {
  const _PurchaseSheet({this.initialValue});
  final PurchaseFormResult? initialValue;

  @override
  State<_PurchaseSheet> createState() => _PurchaseSheetState();
}

class _PurchaseSheetState extends State<_PurchaseSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _itemC,
      _colorC,
      _priceC,
      _qtyC,
      _unitC,
      _notesC;
  late final ValueNotifier<DateTime> _date;

  @override
  void initState() {
    super.initState();
    final v = widget.initialValue;
    _itemC = TextEditingController(text: v?.itemName ?? '');
    _colorC = TextEditingController(text: v?.colorNumber ?? '');
    _priceC = TextEditingController(text: v?.price.toString() ?? '');
    _qtyC = TextEditingController(text: v?.quantity.toString() ?? '');
    _unitC = TextEditingController(text: v?.unit ?? '');
    _notesC = TextEditingController(text: v?.notes ?? '');
    _date = ValueNotifier<DateTime>(v?.purchaseDate ?? DateTime.now());
  }

  @override
  void dispose() {
    _itemC.dispose();
    _colorC.dispose();
    _priceC.dispose();
    _qtyC.dispose();
    _unitC.dispose();
    _notesC.dispose();
    _date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final editing = widget.initialValue != null;
    final ctx = context;
    return ThreadsSheetScaffold(
      title: editing ? l10n.editPurchase : l10n.addPurchase,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateButton(dateNotifier: _date),
            const SizedBox(height: AppSpacing.md),
            _f(_itemC, l10n.itemType, (v) => InputValidator.required(ctx, v)),
            const SizedBox(height: AppSpacing.md),
            _f(
              _colorC,
              l10n.colorNumber,
              (v) => InputValidator.required(ctx, v),
            ),
            const SizedBox(height: AppSpacing.md),
            _nf(_priceC, l10n.price, ctx),
            const SizedBox(height: AppSpacing.md),
            _nf(_qtyC, l10n.quantity, ctx),
            const SizedBox(height: AppSpacing.md),
            _f(_unitC, l10n.unit, (v) => InputValidator.required(ctx, v)),
            const SizedBox(height: AppSpacing.md),
            _f(_notesC, l10n.notes, null, TextInputAction.done, (_) => _save()),
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

  Widget _f(
    TextEditingController c,
    String l,
    String? Function(String?)? v, [
    TextInputAction? a,
    void Function(String)? s,
  ]) => FormTextField(
    controller: c,
    label: l,
    validator: v,
    textInputAction: a,
    onSubmitted: s,
  );

  Widget _nf(TextEditingController c, String l, BuildContext ctx) =>
      FormTextField(
        controller: c,
        label: l,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: InputValidator.multiple([
          (v) => InputValidator.required(ctx, v),
          (v) => InputValidator.positiveNumber(ctx, v),
        ]),
      );

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        PurchaseFormResult(
          purchaseId: widget.initialValue?.purchaseId,
          itemName: _itemC.text.trim(),
          colorNumber: _colorC.text.trim(),
          purchaseDate: _date.value,
          price: double.parse(_priceC.text.trim()),
          quantity: double.parse(_qtyC.text.trim()),
          unit: _unitC.text.trim(),
          notes: _notesC.text.trim().isEmpty ? null : _notesC.text.trim(),
        ),
      );
    }
  }
}
