import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';

class WorkerDeleteDialog extends StatelessWidget {
  const WorkerDeleteDialog({super.key, required this.workerName});

  final String workerName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.deleteWorkerTitle),
      content: Text(l10n.confirmDeleteWorker(workerName)),
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
    );
  }
}
