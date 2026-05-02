import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../shared/presentation/widgets/feature_placeholder_page.dart';

class ThreadsPage extends StatelessWidget {
  const ThreadsPage({super.key});

  static const String routeName = 'threads';
  static const String routePath = '/threads';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholderPage(title: l10n.threads);
  }
}
