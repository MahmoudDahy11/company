import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/input_validator.dart';
import '../models/fault_record_form_result.dart';

class FaultRecordFormContent extends StatelessWidget {
  const FaultRecordFormContent({
    required this.formKey,
    required this.initialValue,
    required this.machineNameController,
    required this.faultNameController,
    required this.costController,
    required this.totalCostController,
    required this.dateNotifier,
    required this.onSave,
    required this.onCostChanged,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final FaultRecordFormResult? initialValue;
  final TextEditingController machineNameController;
  final TextEditingController faultNameController;
  final TextEditingController costController;
  final TextEditingController totalCostController;
  final ValueNotifier<DateTime> dateNotifier;
  final VoidCallback onSave;
  final ValueChanged<String> onCostChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DatePickerButton(dateNotifier: dateNotifier),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: machineNameController,
            decoration: InputDecoration(labelText: l10n.machineName),
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) => InputValidator.required(context, v),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: faultNameController,
            decoration: InputDecoration(labelText: l10n.faultName),
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) => InputValidator.required(context, v),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.cost),
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: InputValidator.multiple([
              (v) => InputValidator.required(context, v),
              (v) => InputValidator.positiveNumber(context, v),
            ]),
            onChanged: onCostChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: totalCostController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.totalCost),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: InputValidator.multiple([
              (v) => InputValidator.required(context, v),
              (v) => InputValidator.positiveNumber(context, v),
            ]),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(onPressed: onSave, child: Text(l10n.save)),
          ),
        ],
      ),
    );
  }
}

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({required this.dateNotifier, super.key});
  final ValueNotifier<DateTime> dateNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
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
            if (picked != null) dateNotifier.value = picked;
          },
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text(DateFormat.yMd().format(value)),
        );
      },
    );
  }
}
