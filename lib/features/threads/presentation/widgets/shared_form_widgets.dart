import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButton extends StatelessWidget {
  const DateButton({super.key, required this.dateNotifier});

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

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
    this.keyboardType,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onFieldSubmitted: onSubmitted,
    );
  }
}
