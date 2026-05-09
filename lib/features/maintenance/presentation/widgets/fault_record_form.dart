import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../models/fault_record_form_result.dart';
import 'adaptive_sheet_helper.dart';
import 'fault_record_form_fields.dart';
import 'form_sheet_scaffold.dart';

Future<FaultRecordFormResult?> showFaultRecordSheet(
  BuildContext context, {
  FaultRecordFormResult? initialValue,
}) {
  return showAdaptiveSheet<FaultRecordFormResult>(
    context: context,
    child: _FaultRecordSheet(initialValue: initialValue),
  );
}

class _FaultRecordSheet extends StatefulWidget {
  const _FaultRecordSheet({this.initialValue});

  final FaultRecordFormResult? initialValue;

  @override
  State<_FaultRecordSheet> createState() => _FaultRecordSheetState();
}

class _FaultRecordSheetState extends State<_FaultRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _machineNameController;
  late final TextEditingController _faultNameController;
  late final TextEditingController _costController;
  late final TextEditingController _totalCostController;
  late final ValueNotifier<DateTime> _dateNotifier;

  @override
  void initState() {
    super.initState();
    _machineNameController = TextEditingController(
      text: widget.initialValue?.machineName ?? '',
    );
    _faultNameController = TextEditingController(
      text: widget.initialValue?.faultName ?? '',
    );
    _costController = TextEditingController(
      text: widget.initialValue?.cost.toString() ?? '',
    );
    _totalCostController = TextEditingController(
      text: widget.initialValue?.totalCost.toString() ?? '',
    );
    _dateNotifier = ValueNotifier<DateTime>(DateTime.now());
  }

  @override
  void dispose() {
    _machineNameController.dispose();
    _faultNameController.dispose();
    _costController.dispose();
    _totalCostController.dispose();
    _dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialValue != null;
    final l10n = AppLocalizations.of(context)!;

    return FormSheetScaffold(
      title: isEditing ? l10n.editFaultRecord : l10n.addFaultRecord,
      child: FaultRecordFormContent(
        formKey: _formKey,
        initialValue: widget.initialValue,
        machineNameController: _machineNameController,
        faultNameController: _faultNameController,
        costController: _costController,
        totalCostController: _totalCostController,
        dateNotifier: _dateNotifier,
        onSave: _save,
        onCostChanged: (_) => _syncTotalCost(),
      ),
    );
  }

  void _syncTotalCost() {
    if (_costController.text.isNotEmpty && _totalCostController.text.isEmpty) {
      _totalCostController.text = _costController.text;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        FaultRecordFormResult(
          id: widget.initialValue?.id,
          machineName: _machineNameController.text.trim(),
          faultName: _faultNameController.text.trim(),
          cost: double.parse(_costController.text.trim()),
          totalCost: double.parse(_totalCostController.text.trim()),
        ),
      );
    }
  }
}
