import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../shared/presentation/widgets/feature_placeholder_page.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  static const String routeName = 'clients';
  static const String routePath = '/clients';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholderPage(title: l10n.clients);
  }
}
