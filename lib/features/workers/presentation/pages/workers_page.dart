import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/workers_cubit.dart';
import '../bloc/workers_state.dart';
import '../widgets/month_selector.dart';
import '../widgets/worker_summary_card.dart';
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
                  Text(
                    l10n.workers,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 320,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: l10n.workersSearchHint,
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: context
                              .read<WorkersCubit>()
                              .updateSearchQuery,
                        ),
                      ),
                      MonthSelector(
                        month: state.selectedMonth,
                        onPrevious: context.read<WorkersCubit>().previousMonth,
                        onNext: context.read<WorkersCubit>().nextMonth,
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final rate = await showStitchRateSheet(context);
                          if (rate != null && context.mounted) {
                            await context.read<WorkersCubit>().updateStitchRate(
                              rate,
                            );
                          }
                        },
                        icon: const Icon(Icons.price_change_outlined),
                        label: Text(l10n.stitchRate),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            await GetIt.I<ExcelExportService>().exportPayroll(
                              workers: state.items,
                              staff: const [],
                              month: state.selectedMonth,
                              isArabic: Localizations.localeOf(context).languageCode == 'ar',
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
                        icon: const Icon(Icons.table_chart_outlined),
                        label: Text(l10n.exportExcel),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.filteredItems.isEmpty
                        ? Center(child: Text(l10n.noWorkersYet))
                        : ListView.separated(
                            itemCount: state.filteredItems.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final item = state.filteredItems[index];
                              return WorkerSummaryCard(
                                item: item,
                                onTap: () => context.push(
                                  WorkersPage.detailsPath(item.id),
                                ),
                                onDelete: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(l10n.deleteWorkerTitle),
                                      content: Text(
                                        l10n.confirmDeleteWorker(item.name),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(l10n.cancel),
                                        ),
                                        FilledButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(l10n.delete),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (shouldDelete == true && context.mounted) {
                                    await context
                                        .read<WorkersCubit>()
                                        .deleteWorker(item.id);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final name = await showWorkerNameSheet(context);
              if (name != null && context.mounted) {
                await context.read<WorkersCubit>().addWorker(name);
              }
            },
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: Text(l10n.addWorker),
          ),
        );
      },
    );
  }
}
