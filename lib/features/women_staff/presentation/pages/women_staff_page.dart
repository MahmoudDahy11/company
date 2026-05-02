import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../shared/presentation/widgets/feature_placeholder_page.dart';

class WomenStaffPage extends StatelessWidget {
  const WomenStaffPage({super.key});

  static const String routeName = 'women-staff';
  static const String routePath = '/women-staff';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholderPage(title: l10n.womenStaff);
  }
}
