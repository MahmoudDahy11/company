import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';

Future<T?> showAdaptiveClientsSheet<T>({
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

class ClientFormResult {
  const ClientFormResult({required this.name, this.phone});

  final String name;
  final String? phone;
}

class ClientModelFormResult {
  const ClientModelFormResult({
    required this.modelName,
    required this.pieceCount,
    required this.pricePerPiece,
    required this.date,
    this.notes,
  });

  final String modelName;
  final int pieceCount;
  final double pricePerPiece;
  final DateTime date;
  final String? notes;
}

class ClientPaymentFormResult {
  const ClientPaymentFormResult({
    required this.amount,
    required this.paymentDate,
    this.notes,
  });

  final double amount;
  final DateTime paymentDate;
  final String? notes;
}

Future<ClientFormResult?> showClientSheet(BuildContext context) {
  return showAdaptiveClientsSheet<ClientFormResult>(
    context: context,
    child: const _ClientSheet(),
  );
}

Future<ClientModelFormResult?> showClientModelSheet(BuildContext context) {
  return showAdaptiveClientsSheet<ClientModelFormResult>(
    context: context,
    child: const _ClientModelSheet(),
  );
}

Future<ClientPaymentFormResult?> showClientPaymentSheet(BuildContext context) {
  return showAdaptiveClientsSheet<ClientPaymentFormResult>(
    context: context,
    child: const _ClientPaymentSheet(),
  );
}

class _ClientSheet extends StatelessWidget {
  const _ClientSheet();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return _ClientsSheetScaffold(
      title: 'إضافة زبون',
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'اسم الزبون'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'رقم الهاتف'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(
                    ClientFormResult(
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim().isEmpty
                          ? null
                          : phoneController.text.trim(),
                    ),
                  );
                }
              },
              child: const Text('حفظ'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientModelSheet extends StatelessWidget {
  const _ClientModelSheet();

  @override
  Widget build(BuildContext context) {
    final modelController = TextEditingController();
    final piecesController = TextEditingController();
    final priceController = TextEditingController();
    final notesController = TextEditingController();
    final dateNotifier = ValueNotifier<DateTime>(DateTime.now());

    return _ClientsSheetScaffold(
      title: 'إضافة موديل',
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
            controller: modelController,
            decoration: const InputDecoration(labelText: 'اسم الموديل'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: piecesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'عدد القطع'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'السعر للقطعة'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: notesController,
            decoration: const InputDecoration(labelText: 'ملاحظات'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final pieces = int.tryParse(piecesController.text.trim());
                final price = double.tryParse(priceController.text.trim());
                if (modelController.text.trim().isNotEmpty &&
                    pieces != null &&
                    price != null) {
                  Navigator.of(context).pop(
                    ClientModelFormResult(
                      modelName: modelController.text.trim(),
                      pieceCount: pieces,
                      pricePerPiece: price,
                      date: dateNotifier.value,
                      notes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                    ),
                  );
                }
              },
              child: const Text('حفظ'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientPaymentSheet extends StatelessWidget {
  const _ClientPaymentSheet();

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    final dateNotifier = ValueNotifier<DateTime>(DateTime.now());

    return _ClientsSheetScaffold(
      title: 'إضافة دفعة',
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
            decoration: const InputDecoration(labelText: 'المبلغ'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: notesController,
            decoration: const InputDecoration(labelText: 'ملاحظات'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                if (amount != null) {
                  Navigator.of(context).pop(
                    ClientPaymentFormResult(
                      amount: amount,
                      paymentDate: dateNotifier.value,
                      notes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                    ),
                  );
                }
              },
              child: const Text('حفظ'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientsSheetScaffold extends StatelessWidget {
  const _ClientsSheetScaffold({required this.title, required this.child});

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
