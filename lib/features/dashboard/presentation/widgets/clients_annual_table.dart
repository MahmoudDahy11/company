import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../clients/presentation/pages/client_details_page.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'annual_bar_chart.dart';

class ClientsAnnualTable extends StatelessWidget {
  const ClientsAnnualTable({
    super.key,
    required this.summaries,
    required this.currency,
  });

  final List<ClientAnnualSummary> summaries;
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
              DataColumn(label: Text(l10n.clientName)),
              DataColumn(label: Text(l10n.totalWork), numeric: true),
              DataColumn(label: Text(l10n.totalPaidHeader), numeric: true),
              DataColumn(label: Text(l10n.remaining), numeric: true),
            ],
            rows: summaries.map((s) {
              final isDimmed = s.remaining <= 0;
              final style = isDimmed
                  ? const TextStyle(color: Colors.grey)
                  : const TextStyle(fontWeight: FontWeight.bold);
              return DataRow(
                onSelectChanged: (_) => context.goNamed(
                  ClientDetailsPage.routeName,
                  pathParameters: {'clientId': s.clientId.toString()},
                ),
                cells: [
                  DataCell(Text(s.name, style: style)),
                  DataCell(Text(currency.format(s.totalWork), style: style)),
                  DataCell(Text(currency.format(s.totalPaid), style: style)),
                  DataCell(
                    Text(
                      currency.format(s.remaining),
                      style: style.copyWith(
                        color: s.remaining > 0 ? Colors.red : null,
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
          secondColor: Colors.red,
        ),
      ],
    );
  }
}
