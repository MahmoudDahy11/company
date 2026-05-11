import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/staff_list_item.dart';
import 'staff_table_row_actions.dart';

class StaffListTable extends StatelessWidget {
  const StaffListTable({super.key, required this.items});

  final List<StaffListItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String currency(double value) => NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '',
      decimalDigits: 2,
    ).format(value).trim();

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.womenStaffList,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(color: Colors.grey.shade200, width: 1),
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
              headingTextStyle: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
              dataRowMaxHeight: 64,
              dataRowMinHeight: 64,
              columns: [
                DataColumn(label: Text(l10n.name)),
                DataColumn(label: Text(l10n.basicSalary)),
                DataColumn(label: Text(l10n.advancesHeader)),
                DataColumn(label: Text(l10n.deductions)),
                DataColumn(label: Text(l10n.netSalaryHeader)),
                DataColumn(label: Text(l10n.actions)),
              ],
              rows: items
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 140),
                            child: Text(item.name),
                          ),
                        ),
                        DataCell(Text(currency(item.monthlySalary))),
                        DataCell(Text(currency(item.totalAdvances))),
                        DataCell(Text(currency(item.totalDeductions))),
                        DataCell(Text(currency(item.netSalary))),
                        DataCell(StaffTableRowActions(item: item)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
