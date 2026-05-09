import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/worker_list_item.dart';
import '../bloc/workers_cubit.dart';
import '../pages/workers_page.dart';
import 'worker_delete_dialog.dart';

class WorkersDataTable extends StatelessWidget {
  const WorkersDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              l10n.workersList,
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
                DataColumn(label: Text(l10n.netSalaryHeader)),
                DataColumn(label: Text(l10n.advancesHeader)),
                DataColumn(label: Text(l10n.deductions)),
                DataColumn(label: Text(l10n.absentDaysHeader)),
                DataColumn(label: Text(l10n.actions)),
              ],
              rows: context
                  .watch<WorkersCubit>()
                  .state
                  .filteredItems
                  .map((item) => _buildRow(context, item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(BuildContext context, WorkerListItem item) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '',
      decimalDigits: 2,
    );

    return DataRow(
      cells: [
        DataCell(Text(item.name)),
        DataCell(Text(fmt.format(item.netSalary).trim())),
        DataCell(Text(fmt.format(item.totalAdvances).trim())),
        DataCell(Text(fmt.format(item.totalDeductions).trim())),
        DataCell(Text(item.absentDays.toString())),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () => context.push(WorkersPage.detailsPath(item.id)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1F2937),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Text(l10n.details),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () => _confirmDelete(context, item),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WorkerListItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => WorkerDeleteDialog(workerName: item.name),
    );
    if (confirm == true && context.mounted) {
      context.read<WorkersCubit>().deleteWorker(item.id);
    }
  }
}
