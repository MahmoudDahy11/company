import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../domain/entities/financial_filter.dart';

class FinancialFilterSelector extends StatelessWidget {
  const FinancialFilterSelector({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final FinancialFilter current;
  final ValueChanged<FinancialFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<FinancialFilter>(
      segments: [
        ButtonSegment(
          value: FinancialFilter.last3Months,
          label: Text(l10n.last3Months),
        ),
        ButtonSegment(
          value: FinancialFilter.last6Months,
          label: Text(l10n.last6Months),
        ),
        ButtonSegment(
          value: FinancialFilter.lastYear,
          label: Text(l10n.lastYear),
        ),
      ],
      selected: {current},
      onSelectionChanged: (set) => onChanged(set.first),
    );
  }
}
