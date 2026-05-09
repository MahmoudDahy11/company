import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/worker_advance.dart';
import '../../domain/entities/worker_production.dart';
import '../bloc/worker_details_cubit.dart';
import '../bloc/worker_details_state.dart';
import '../widgets/month_selector.dart';
import '../../domain/entities/worker_deduction.dart';
import '../widgets/workers_forms.dart';

class WorkerDetailsPage extends StatelessWidget {
  const WorkerDetailsPage({super.key, required this.workerId});

  static const String routeName = 'worker-details';
  static const String routePath = 'details/:workerId';

  final int workerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<WorkerDetailsCubit>()..init(workerId),
      child: const _WorkerDetailsView(),
    );
  }
}

class _WorkerDetailsView extends StatelessWidget {
  const _WorkerDetailsView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: BlocBuilder<WorkerDetailsCubit, WorkerDetailsState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          final details = state.details;
          final currency = NumberFormat.currency(
            locale: Localizations.localeOf(context).toLanguageTag(),
            symbol: 'EGP ',
            decimalDigits: 2,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(details?.worker.name ?? l10n.workerDetailsTitle),
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.summaryTab),
                  Tab(text: l10n.productionTab),
                  Tab(text: l10n.advancesTab),
                  Tab(text: l10n.deductions),
                ],
              ),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : details == null
                ? Center(
                    child: Text(state.errorMessage ?? l10n.failedToLoadData),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MonthSelector(
                              month: state.selectedMonth,
                              onPrevious: context
                                  .read<WorkerDetailsCubit>()
                                  .previousMonth,
                              onNext: context
                                  .read<WorkerDetailsCubit>()
                                  .nextMonth,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              l10n.registrationDate(
                                DateFormat.yMd().format(
                                  details.worker.createdAt,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.currentRatePer100k(
                                currency.format(details.summary.appliedRate),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _SummaryTab(state: state, currency: currency),
                            _ProductionTab(
                              productions: details.productions,
                              currency: currency,
                            ),
                            _AdvancesTab(
                              advances: details.advances,
                              currency: currency,
                            ),
                            _DeductionsTab(
                              deductions: details.deductions,
                              currency: currency,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: details == null
                ? null
                : _DetailsFab(
                    onAddProduction: () => _onAddProduction(context),
                    onAddAdvance: () => _onAddAdvance(context),
                    onAddDeduction: () => _onAddDeduction(context),
                    onAbsentDays: () =>
                        _onAbsentDays(context, details.summary.absentDays),
                  ),
          );
        },
      ),
    );
  }

  Future<void> _onAddProduction(BuildContext context) async {
    final result = await showProductionSheet(context);
    if (result == null || !context.mounted) {
      return;
    }
    await context.read<WorkerDetailsCubit>().saveProduction(
      date: result.date,
      stitchCount: result.stitchCount,
      notes: result.notes,
    );
  }

  Future<void> _onAddAdvance(BuildContext context) async {
    final result = await showAdvanceSheet(context);
    if (result == null || !context.mounted) {
      return;
    }
    await context.read<WorkerDetailsCubit>().saveAdvance(
      advanceId: result.advanceId,
      amount: result.amount,
      date: result.date,
      notes: result.notes,
    );
  }

  Future<void> _onAddDeduction(BuildContext context) async {
    final result = await showDeductionSheet(context);
    if (result == null || !context.mounted) {
      return;
    }
    await context.read<WorkerDetailsCubit>().addDeduction(
      amount: result.amount,
      date: result.date,
      notes: result.notes,
    );
  }

  Future<void> _onAbsentDays(BuildContext context, int currentValue) async {
    final result = await showAbsentDaysSheet(
      context,
      initialValue: currentValue,
    );
    if (result == null || !context.mounted) {
      return;
    }
    await context.read<WorkerDetailsCubit>().saveAbsentDays(result);
  }
}

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({required this.state, required this.currency});

  final WorkerDetailsState state;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summary = state.details!.summary;
    final items = <({String label, String value})>[
      (
        label: l10n.totalStitches,
        value: NumberFormat.decimalPattern().format(summary.totalStitchCount),
      ),
      (label: l10n.earnings, value: currency.format(summary.totalEarnings)),
      (label: l10n.advances, value: currency.format(summary.totalAdvances)),
      (label: l10n.deductions, value: currency.format(summary.totalDeductions)),
      (label: l10n.carryOver, value: currency.format(summary.carryOver)),
      (label: l10n.absentDays, value: summary.absentDays.toString()),
      (label: l10n.netSalary, value: currency.format(summary.netSalary)),
    ];

    return RefreshIndicator(
      onRefresh: () => context.read<WorkerDetailsCubit>().refresh(),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 260,
          mainAxisExtent: 120,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.label),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.value,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductionTab extends StatelessWidget {
  const _ProductionTab({required this.productions, required this.currency});

  final List<WorkerProduction> productions;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    if (productions.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noProductionThisMonth),
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
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(thickness: 1, space: 1),
            ),
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
                DataColumn(label: Text(l10n.stitchCount)),
                DataColumn(label: Text(l10n.earnings)),
                DataColumn(label: Text(l10n.notes)),
                DataColumn(label: Text(l10n.actions)),
              ],
              rows: productions.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(DateFormat.yMd().format(item.date))),
                    DataCell(
                      Text(
                        NumberFormat.decimalPattern().format(item.stitchCount),
                      ),
                    ),
                    DataCell(Text(currency.format(item.dailyEarnings))),
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
                              final result = await showProductionSheet(
                                context,
                                initialValue: ProductionFormResult(
                                  productionId: item.id,
                                  date: item.date,
                                  stitchCount: item.stitchCount,
                                  notes: item.notes,
                                ),
                              );
                              if (result == null || !context.mounted) {
                                return;
                              }
                              await context
                                  .read<WorkerDetailsCubit>()
                                  .saveProduction(
                                    productionId: item.id,
                                    date: result.date,
                                    stitchCount: result.stitchCount,
                                    notes: result.notes,
                                  );
                            },
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            onPressed: () async {
                              final l10n = AppLocalizations.of(context)!;
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.deleteProductionTitle),
                                  content: Text(l10n.confirmDeleteProduction),
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
                                    .deleteProduction(item.id);
                              }
                            },
                            icon: const Icon(Icons.delete_outline, size: 20),
                            visualDensity: VisualDensity.compact,
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
      ),
    );
  }
}

class _AdvancesTab extends StatelessWidget {
  const _AdvancesTab({required this.advances, required this.currency});

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
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(thickness: 1, space: 1),
            ),
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
              rows: advances.map((item) {
                return DataRow(
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
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeductionsTab extends StatelessWidget {
  const _DeductionsTab({required this.deductions, required this.currency});

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
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(thickness: 1, space: 1),
            ),
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
              rows: deductions.map((item) {
                return DataRow(
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
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsFab extends StatelessWidget {
  const _DetailsFab({
    required this.onAddProduction,
    required this.onAddAdvance,
    required this.onAddDeduction,
    required this.onAbsentDays,
  });

  final VoidCallback onAddProduction;
  final VoidCallback onAddAdvance;
  final VoidCallback onAddDeduction;
  final VoidCallback onAbsentDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.add),
      onSelected: (callback) => callback(),
      itemBuilder: (context) => [
        PopupMenuItem<VoidCallback>(
          value: onAddProduction,
          child: Text(l10n.addProduction),
        ),
        PopupMenuItem<VoidCallback>(
          value: onAddAdvance,
          child: Text(l10n.addAdvance),
        ),
        PopupMenuItem<VoidCallback>(
          value: onAddDeduction,
          child: Text(l10n.addDeduction),
        ),
        PopupMenuItem<VoidCallback>(
          value: onAbsentDays,
          child: Text(l10n.absentDays),
        ),
      ],
    );
  }
}
