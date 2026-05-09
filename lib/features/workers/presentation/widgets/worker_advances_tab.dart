import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/worker_advance.dart';
import '../bloc/worker_details_cubit.dart';
import '../widgets/workers_forms.dart';

class WorkerAdvancesTab extends StatelessWidget {
  const WorkerAdvancesTab({
    super.key,
    required this.advances,
    required this.currency,
  });

  final List<WorkerAdvance> advances;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    if (advances.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noAdvancesThisMonth),
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
            rows: advances
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
                        item.carriedOver
                            ? Chip(
                                label: Text(l10n.carryOver),
                                visualDensity: VisualDensity.compact,
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final result = await showAdvanceSheet(
                                        context,
                                        initialValue: AdvanceFormResult(
                                          advanceId: item.id,
                                          date: item.date,
                                          amount: item.amount,
                                          notes: item.notes,
                                        ),
                                      );
                                      if (result == null || !context.mounted) {
                                        return;
                                      }
                                      await context
                                          .read<WorkerDetailsCubit>()
                                          .saveAdvance(
                                            advanceId: item.id,
                                            amount: result.amount,
                                            date: result.date,
                                            notes: result.notes,
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(l10n.deleteAdvanceTitle),
                                          content: Text(
                                            l10n.confirmDeleteAdvance,
                                          ),
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
                                            .deleteAdvance(item.id);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                    ),
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
