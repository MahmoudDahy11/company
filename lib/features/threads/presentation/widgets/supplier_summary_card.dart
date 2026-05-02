import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/supplier_list_item.dart';

class SupplierSummaryCard extends StatelessWidget {
  const SupplierSummaryCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final SupplierListItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    tooltip: l10n.deleteSupplierTitle,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.totalPurchases(currency.format(item.totalPurchased))),
              Text(l10n.totalPaid(currency.format(item.totalPaid))),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.outstanding(currency.format(item.outstandingBalance)),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
