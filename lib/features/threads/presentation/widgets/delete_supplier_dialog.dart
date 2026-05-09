import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';

Future<bool?> showDeleteSupplierDialog(
  BuildContext context,
  String supplierName,
) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.deleteSupplierTitle),
      content: Text(l10n.confirmDeleteSupplier(supplierName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
}
