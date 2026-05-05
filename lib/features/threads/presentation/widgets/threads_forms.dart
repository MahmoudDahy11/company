import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';

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

class _SupplierSheet extends StatelessWidget {
  const _SupplierSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return _ThreadsSheetScaffold(
      title: l10n.addSupplier,
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: l10n.supplierName),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: l10n.phoneNumber),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(
                    SupplierFormResult(
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim().isEmpty
                          ? null
                          : phoneController.text.trim(),
                    ),
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}

class _PurchaseSheet extends StatelessWidget {
  const _PurchaseSheet({this.initialValue});

  final PurchaseFormResult? initialValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemController = TextEditingController(
      text: initialValue?.itemName ?? '',
    );
    final colorController = TextEditingController(
      text: initialValue?.colorNumber ?? '',
    );
    final priceController = TextEditingController(
      text: initialValue?.price.toString() ?? '',
    );
    final quantityController = TextEditingController(
      text: initialValue?.quantity.toString() ?? '',
    );
    final unitController = TextEditingController(
      text: initialValue?.unit ?? '',
    );
    final notesController = TextEditingController(
      text: initialValue?.notes ?? '',
    );
    final dateNotifier = ValueNotifier<DateTime>(
      initialValue?.purchaseDate ?? DateTime.now(),
    );

    return _ThreadsSheetScaffold(
      title: initialValue == null ? l10n.addPurchase : l10n.editPurchase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: dateNotifier,
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
                    dateNotifier.value = picked;
                  }
                },
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(DateFormat.yMd().format(value)),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: itemController,
            decoration: InputDecoration(labelText: l10n.itemType),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: colorController,
            decoration: InputDecoration(labelText: l10n.colorNumber),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.price),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.quantity),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: unitController,
            decoration: InputDecoration(labelText: l10n.unit),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: notesController,
            decoration: InputDecoration(labelText: l10n.notes),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final price = double.tryParse(priceController.text.trim());
                final quantity = double.tryParse(
                  quantityController.text.trim(),
                );
                if (itemController.text.trim().isNotEmpty &&
                    colorController.text.trim().isNotEmpty &&
                    unitController.text.trim().isNotEmpty &&
                    price != null &&
                    quantity != null) {
                  Navigator.of(context).pop(
                    PurchaseFormResult(
                      purchaseId: initialValue?.purchaseId,
                      itemName: itemController.text.trim(),
                      colorNumber: colorController.text.trim(),
                      purchaseDate: dateNotifier.value,
                      price: price,
                      quantity: quantity,
                      unit: unitController.text.trim(),
                      notes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                    ),
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupplierPaymentSheet extends StatelessWidget {
  const _SupplierPaymentSheet({this.initialValue});

  final SupplierPaymentFormResult? initialValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amountController = TextEditingController(
      text: initialValue?.amount.toString() ?? '',
    );
    final notesController = TextEditingController(
      text: initialValue?.notes ?? '',
    );
    final dateNotifier = ValueNotifier<DateTime>(
      initialValue?.paymentDate ?? DateTime.now(),
    );

    return _ThreadsSheetScaffold(
      title: initialValue == null ? l10n.addPayment : l10n.editPayment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: dateNotifier,
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
                    dateNotifier.value = picked;
                  }
                },
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(DateFormat.yMd().format(value)),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.amount),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: notesController,
            decoration: InputDecoration(labelText: l10n.notes),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                if (amount != null) {
                  Navigator.of(context).pop(
                    SupplierPaymentFormResult(
                      paymentId: initialValue?.paymentId,
                      amount: amount,
                      paymentDate: dateNotifier.value,
                      notes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                    ),
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
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
