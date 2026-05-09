import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';

class WorkerDetailsFab extends StatelessWidget {
  const WorkerDetailsFab({
    super.key,
    required this.onAddProduction,
    required this.onAddAdvance,
    required this.onAbsentDays,
  });

  final VoidCallback onAddProduction;
  final VoidCallback onAddAdvance;
  final VoidCallback onAbsentDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.add),
      onSelected: (callback) => callback(),
      itemBuilder: (context) => [
        PopupMenuItem(value: onAddProduction, child: Text(l10n.addProduction)),
        PopupMenuItem(value: onAddAdvance, child: Text(l10n.addAdvance)),
        PopupMenuItem(value: onAbsentDays, child: Text(l10n.absentDays)),
      ],
    );
  }
}
