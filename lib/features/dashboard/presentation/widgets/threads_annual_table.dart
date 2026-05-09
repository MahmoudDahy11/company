import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../threads/presentation/pages/supplier_details_page.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'annual_bar_chart.dart';

class ThreadsAnnualTable extends StatelessWidget {
  const ThreadsAnnualTable({
    super.key,
    required this.summaries,
    required this.currency,
  });

  final List<SupplierAnnualSummary> summaries;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text(l10n.supplierName)),
              DataColumn(label: Text(l10n.totalPurchasesHeader), numeric: true),
              DataColumn(label: Text(l10n.totalPaidHeader), numeric: true),
              DataColumn(label: Text(l10n.remainingOur), numeric: true),
            ],
            rows: summaries.map((s) {
              return DataRow(
                onSelectChanged: (_) => context.goNamed(
                  SupplierDetailsPage.routeName,
                  pathParameters: {'supplierId': s.supplierId.toString()},
                ),
                cells: [
                  DataCell(Text(s.name)),
                  DataCell(Text(currency.format(s.totalPurchases))),
                  DataCell(Text(currency.format(s.totalPaid))),
                  DataCell(
                    Text(
                      currency.format(s.remaining),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AnnualBarChart(
          items: summaries
              .map(
                (s) => (name: s.name, first: s.totalPaid, second: s.remaining),
              )
              .toList(),
          firstColor: Colors.green,
          secondColor: Colors.orange,
        ),
      ],
    );
  }
}
