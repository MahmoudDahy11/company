import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_spacing.dart';

class DashboardMonthSelector extends StatelessWidget {
  const DashboardMonthSelector({
    super.key,
    required this.month,
    required this.onChanged,
  });

  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    final months = List.generate(12, (index) {
      final m = DateTime(month.year, index + 1);
      return DropdownMenuItem(
        value: index + 1,
        child: Text(DateFormat.MMMM(locale).format(m)),
      );
    });

    final years = List.generate(10, (index) {
      final y = DateTime.now().year - 5 + index;
      return DropdownMenuItem(value: y, child: Text(y.toString()));
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DropdownContainer(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: month.year,
              items: years,
              onChanged: (y) {
                if (y != null) onChanged(DateTime(y, month.month));
              },
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _DropdownContainer(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: month.month,
              items: months,
              onChanged: (m) {
                if (m != null) onChanged(DateTime(month.year, m));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownContainer extends StatelessWidget {
  const _DropdownContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}
