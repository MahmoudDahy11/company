import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/workers_cubit.dart';
import '../bloc/workers_state.dart';
import '../widgets/workers_forms.dart';

class WorkersPage extends StatelessWidget {
  const WorkersPage({super.key});

  static const String routeName = 'workers';
  static const String routePath = '/workers';
  static String detailsPath(int workerId) => '$routePath/details/$workerId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<WorkersCubit>()..start(),
      child: const _WorkersView(),
    );
  }
}

class _WorkersView extends StatelessWidget {
  const _WorkersView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkersCubit, WorkersState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () async {
                              final name = await showWorkerNameSheet(context);
                              if (name != null && context.mounted) {
                                await context.read<WorkersCubit>().addWorker(
                                  name,
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addWorker),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF374151),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          OutlinedButton.icon(
                            onPressed: () async {
                              try {
                                await GetIt.I<ExcelExportService>()
                                    .exportPayroll(
                                      workers: state.items,
                                      staff: const [],
                                      month: state.selectedMonth,
                                      isArabic:
                                          Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar',
                                    );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.exportSuccess)),
                                  );
                                }
                              } catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.exportError)),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.download_outlined),
                            label: Text(l10n.exportExcel),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final rate = await showStitchRateSheet(context);
                              if (rate != null && context.mounted) {
                                await context
                                    .read<WorkersCubit>()
                                    .updateStitchRate(rate);
                              }
                            },
                            icon: const Icon(Icons.price_change_outlined),
                            label: Text(l10n.stitchRate),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 250,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: l10n.workersSearchHint,
                                prefixIcon: const Icon(Icons.search),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              onChanged: context
                                  .read<WorkersCubit>()
                                  .updateSearchQuery,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Text(
                            l10n.workers,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1F2937),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.filteredItems.isEmpty
                        ? Center(child: Text(l10n.noWorkersYet))
                        : Card(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1F2937),
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: DataTable(
                                      border: TableBorder.all(
                                        color: Colors.grey.shade200,
                                        width: 1,
                                      ),
                                      headingRowColor: WidgetStateProperty.all(
                                        Colors.grey.shade50,
                                      ),
                                      headingTextStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      dataRowMaxHeight: 64,
                                      dataRowMinHeight: 64,
                                      columns: [
                                        DataColumn(label: Text(l10n.name)),
                                        DataColumn(
                                          label: Text(l10n.netSalaryHeader),
                                        ),
                                        DataColumn(
                                          label: Text(l10n.advancesHeader),
                                        ),
                                        DataColumn(
                                          label: Text(l10n.absentDaysHeader),
                                        ),
                                        DataColumn(label: Text(l10n.actions)),
                                      ],
                                      rows: state.filteredItems.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(item.name)),
                                            DataCell(
                                              Text(
                                                NumberFormat.currency(
                                                  locale:
                                                      Localizations.localeOf(
                                                        context,
                                                      ).toLanguageTag(),
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                ).format(item.netSalary).trim(),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                NumberFormat.currency(
                                                      locale:
                                                          Localizations.localeOf(
                                                            context,
                                                          ).toLanguageTag(),
                                                      symbol: '',
                                                      decimalDigits: 2,
                                                    )
                                                    .format(item.totalAdvances)
                                                    .trim(),
                                              ),
                                            ),
                                            DataCell(const Text('0')),
                                            DataCell(
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  OutlinedButton(
                                                    onPressed: () => context.push(
                                                      WorkersPage.detailsPath(
                                                        item.id,
                                                      ),
                                                    ),
                                                    style:
                                                        OutlinedButton.styleFrom(
                                                          foregroundColor:
                                                              const Color(
                                                                0xFF1F2937,
                                                              ),
                                                          side: BorderSide(
                                                            color: Colors
                                                                .grey
                                                                .shade300,
                                                          ),
                                                        ),
                                                    child: Text(l10n.details),
                                                  ),
                                                  const SizedBox(
                                                    width: AppSpacing.sm,
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      final confirm = await showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text(
                                                            l10n.deleteWorkerTitle,
                                                          ),
                                                          content: Text(
                                                            l10n.confirmDeleteWorker(
                                                              item.name,
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                    false,
                                                                  ),
                                                              child: Text(
                                                                l10n.cancel,
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                    true,
                                                                  ),
                                                              style: TextButton.styleFrom(
                                                                foregroundColor:
                                                                    Colors.red,
                                                              ),
                                                              child: Text(
                                                                l10n.delete,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                      if (confirm == true &&
                                                          context.mounted) {
                                                        context
                                                            .read<
                                                              WorkersCubit
                                                            >()
                                                            .deleteWorker(
                                                              item.id,
                                                            );
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
