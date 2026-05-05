import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';

Future<T?> showAdaptiveThreadsSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  if (MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop) {
    return showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: child,
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) => child,
  );
}

class SupplierFormResult {
  const SupplierFormResult({required this.name, this.phone});

  final String name;
  final String? phone;
}

class PurchaseFormResult {
  const PurchaseFormResult({
    required this.itemName,
    required this.colorNumber,
    required this.purchaseDate,
    required this.price,
    required this.quantity,
    required this.unit,
    this.notes,
    this.purchaseId,
  });

  final String itemName;
  final String colorNumber;
  final DateTime purchaseDate;
  final double price;
  final double quantity;
  final String unit;
  final String? notes;
  final int? purchaseId;
}

class SupplierPaymentFormResult {
  const SupplierPaymentFormResult({
    required this.amount,
    required this.paymentDate,
    this.notes,
    this.paymentId,
  });

  final double amount;
  final DateTime paymentDate;
  final String? notes;
  final int? paymentId;
}

Future<SupplierFormResult?> showSupplierSheet(BuildContext context) {
  return showAdaptiveThreadsSheet<SupplierFormResult>(
    context: context,
    child: const _SupplierSheet(),
  );
}

Future<PurchaseFormResult?> showPurchaseSheet(
  BuildContext context, {
  PurchaseFormResult? initialValue,
}) {
  return showAdaptiveThreadsSheet<PurchaseFormResult>(
    context: context,
    child: _PurchaseSheet(initialValue: initialValue),
  );
}

Future<SupplierPaymentFormResult?> showSupplierPaymentSheet(
  BuildContext context, {
  SupplierPaymentFormResult? initialValue,
}) {
  return showAdaptiveThreadsSheet<SupplierPaymentFormResult>(
    context: context,
    child: _SupplierPaymentSheet(initialValue: initialValue),
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

    return _ThreadsSheetScaffold(
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

class _PurchaseSheet extends StatefulWidget {
  const _PurchaseSheet({this.initialValue});

  final PurchaseFormResult? initialValue;

  @override
  State<_PurchaseSheet> createState() => _PurchaseSheetState();
}

class _PurchaseSheetState extends State<_PurchaseSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _itemController;
  late final TextEditingController _colorController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitController;
  late final TextEditingController _notesController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController(
      text: widget.initialValue?.itemName ?? '',
    );
    _colorController = TextEditingController(
      text: widget.initialValue?.colorNumber ?? '',
    );
    _priceController = TextEditingController(
      text: widget.initialValue?.price.toString() ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.initialValue?.quantity.toString() ?? '',
    );
    _unitController = TextEditingController(
      text: widget.initialValue?.unit ?? '',
    );
    _notesController = TextEditingController(
      text: widget.initialValue?.notes ?? '',
    );
    _dateNotifier = ValueNotifier<DateTime>(
      widget.initialValue?.purchaseDate ?? DateTime.now(),
    );
  }

  @override
  void dispose() {
    _itemController.dispose();
    _colorController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    _dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _ThreadsSheetScaffold(
      title: widget.initialValue == null ? l10n.addPurchase : l10n.editPurchase,
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
                    if (picked != null) {
                      _dateNotifier.value = picked;
                    }
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(DateFormat.yMd().format(value)),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _itemController,
              decoration: InputDecoration(labelText: l10n.itemType),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => InputValidator.required(context, v),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _colorController,
              decoration: InputDecoration(labelText: l10n.colorNumber),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => InputValidator.required(context, v),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.price),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _quantityController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.quantity),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _unitController,
              decoration: InputDecoration(labelText: l10n.unit),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => InputValidator.required(context, v),
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
        PurchaseFormResult(
          purchaseId: widget.initialValue?.purchaseId,
          itemName: _itemController.text.trim(),
          colorNumber: _colorController.text.trim(),
          purchaseDate: _dateNotifier.value,
          price: double.parse(_priceController.text.trim()),
          quantity: double.parse(_quantityController.text.trim()),
          unit: _unitController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }
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
    _amountController = TextEditingController(
      text: widget.initialValue?.amount.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.initialValue?.notes ?? '',
    );
    _dateNotifier = ValueNotifier<DateTime>(
      widget.initialValue?.paymentDate ?? DateTime.now(),
    );
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

    return _ThreadsSheetScaffold(
      title: widget.initialValue == null ? l10n.addPayment : l10n.editPayment,
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
                    if (picked != null) {
                      _dateNotifier.value = picked;
                    }
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(DateFormat.yMd().format(value)),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.amount),
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

class _ThreadsSheetScaffold extends StatelessWidget {
  const _ThreadsSheetScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
