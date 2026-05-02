import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/staff_list_item.dart';

class StaffSummaryCard extends StatelessWidget {
  const StaffSummaryCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final StaffListItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: 'EGP ',
      decimalDigits: 2,
    );

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'حذف الموظفة',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('الراتب: ${currency.format(item.monthlySalary)}'),
              Text('السلف: ${currency.format(item.totalAdvances)}'),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'الصافي: ${currency.format(item.netSalary)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
