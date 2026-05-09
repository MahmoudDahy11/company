import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/worker_deduction.dart';
import '../bloc/worker_details_cubit.dart';

class WorkerDeductionsTab extends StatelessWidget {
  const WorkerDeductionsTab({
    super.key,
    required this.deductions,
    required this.currency,
  });

  final List<WorkerDeduction> deductions;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    if (deductions.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noDeductionsThisMonth),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () => context.read<WorkerDetailsCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            headingRowColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            border: TableBorder.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
            columns: [
              DataColumn(label: Text(l10n.date)),
              DataColumn(label: Text(l10n.amount)),
              DataColumn(label: Text(l10n.notes)),
              DataColumn(label: Text(l10n.actions)),
            ],
            rows: deductions
                .map(
                  (item) => DataRow(
                    cells: [
                      DataCell(Text(DateFormat.yMd().format(item.date))),
                      DataCell(Text(currency.format(item.amount))),
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            item.notes ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(l10n.deleteDeductionTitle),
                                    content: Text(l10n.confirmDeleteDeduction),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(l10n.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: Text(l10n.delete),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true && context.mounted) {
                                  context
                                      .read<WorkerDetailsCubit>()
                                      .deleteDeduction(item.id);
                                }
                              },
                              icon: const Icon(Icons.delete_outline, size: 20),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
