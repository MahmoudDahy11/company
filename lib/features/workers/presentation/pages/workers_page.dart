import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../shared/presentation/widgets/feature_placeholder_page.dart';

class WorkersPage extends StatelessWidget {
  const WorkersPage({super.key});

  static const String routeName = 'workers';
  static const String routePath = '/workers';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholderPage(title: l10n.workers);
  }
}
