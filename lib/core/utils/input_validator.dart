import 'package:flutter/material.dart';

import '../localization/generated/app_localizations.dart';

/// A centralized, l10n-aware input validation system.
///
/// All validation methods accept a [BuildContext] to resolve localized error
/// messages.  Use [multiple] to compose several rules for a single field.
///
/// ### Extending for custom business rules
/// Add a new static method that follows the same signature:
/// ```dart
/// static String? myCustomRule(BuildContext context, String? value) {
///   if (/* fails */) return AppLocalizations.of(context)!.myCustomError;
///   return null;
/// }
/// ```
/// Then compose it: `InputValidator.multiple([...])`.
class InputValidator {
  const InputValidator._();

  // ──────────────────────── Core rules ────────────────────────

  /// Field must not be empty or whitespace-only.
  static String? required(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.requiredField;
    }
    return null;
  }

  /// Value must be a valid email address.
  static String? email(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;

    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    return null;
  }

  /// Password must have ≥ 8 chars, at least one uppercase letter and one digit.
  static String? password(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length < 8) {
      return AppLocalizations.of(context)!.passwordTooShort;
    }
    if (!value.contains(RegExp(r'[A-Z]')) ||
        !value.contains(RegExp(r'[0-9]'))) {
      return AppLocalizations.of(context)!.passwordTooWeak;
    }
    return null;
  }

  /// Value must match a phone-number pattern (10–15 digits, optional leading +).
  static String? phone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;

    final regex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidPhone;
    }
    return null;
  }

  /// Value must be a valid number and optionally within [min]..[max].
  static String? range(
    BuildContext context,
    String? value, {
    double? min,
    double? max,
  }) {
    if (value == null || value.isEmpty) return null;

    final num = double.tryParse(value);
    if (num == null) {
      return AppLocalizations.of(context)!.invalidNumber;
    }
    if (min != null && num < min) {
      return AppLocalizations.of(context)!.valueTooSmall(min.toString());
    }
    if (max != null && num > max) {
      return AppLocalizations.of(context)!.valueTooLarge(max.toString());
    }
    return null;
  }

  /// Value must be a positive number (> 0).
  static String? positiveNumber(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;

    final num = double.tryParse(value);
    if (num == null) {
      return AppLocalizations.of(context)!.invalidNumber;
    }
    if (num <= 0) {
      return AppLocalizations.of(context)!.amountMustBePositive;
    }
    return null;
  }

  // ──────────────────── Composite helper ──────────────────────

  /// Chains multiple validators and returns the **first** error encountered.
  ///
  /// ```dart
  /// TextFormField(
  ///   validator: InputValidator.multiple([
  ///     (v) => InputValidator.required(context, v),
  ///     (v) => InputValidator.email(context, v),
  ///   ]),
  /// )
  /// ```
  static String? Function(String?) multiple(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
