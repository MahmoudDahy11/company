import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';

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
    this.modelId,
  });

  final String modelName;
  final int pieceCount;
  final double pricePerPiece;
  final DateTime date;
  final String? notes;
  final int? modelId;
}

class ClientPaymentFormResult {
  const ClientPaymentFormResult({
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

Future<ClientFormResult?> showClientSheet(BuildContext context) {
  return showAdaptiveClientsSheet<ClientFormResult>(
    context: context,
    child: const _ClientSheet(),
  );
}

Future<ClientModelFormResult?> showClientModelSheet(
  BuildContext context, {
  ClientModelFormResult? initialValue,
}) {
  return showAdaptiveClientsSheet<ClientModelFormResult>(
    context: context,
    child: _ClientModelSheet(initialValue: initialValue),
  );
}

Future<ClientPaymentFormResult?> showClientPaymentSheet(
  BuildContext context, {
  ClientPaymentFormResult? initialValue,
}) {
  return showAdaptiveClientsSheet<ClientPaymentFormResult>(
    context: context,
    child: _ClientPaymentSheet(initialValue: initialValue),
  );
}

class _ClientSheet extends StatefulWidget {
  const _ClientSheet();

  @override
  State<_ClientSheet> createState() => _ClientSheetState();
}

class _ClientSheetState extends State<_ClientSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _ClientsSheetScaffold(
      title: l10n.addClient,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.clientName),
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
        ClientFormResult(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        ),
      );
    }
  }
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

    return _ClientsSheetScaffold(
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
              controller: _modelController,
              decoration: InputDecoration(labelText: l10n.modelName),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => InputValidator.required(context, v),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _piecesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.pieceCount),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: InputValidator.multiple([
                (v) => InputValidator.required(context, v),
                (v) => InputValidator.positiveNumber(context, v),
              ]),
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

class _ClientPaymentSheet extends StatefulWidget {
  const _ClientPaymentSheet({this.initialValue});

  final ClientPaymentFormResult? initialValue;

  @override
  State<_ClientPaymentSheet> createState() => _ClientPaymentSheetState();
}

class _ClientPaymentSheetState extends State<_ClientPaymentSheet> {
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

    return _ClientsSheetScaffold(
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
              textInputAction: TextInputAction.next,
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
        ClientPaymentFormResult(
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
