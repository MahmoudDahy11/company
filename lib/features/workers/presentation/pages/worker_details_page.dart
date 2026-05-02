import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/worker_advance.dart';
import '../../domain/entities/worker_production.dart';
import '../bloc/worker_details_cubit.dart';
import '../bloc/worker_details_state.dart';
import '../widgets/month_selector.dart';
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
      length: 3,
      child: BlocBuilder<WorkerDetailsCubit, WorkerDetailsState>(
        builder: (context, state) {
          final details = state.details;
          final currency = NumberFormat.currency(
            locale: Localizations.localeOf(context).toLanguageTag(),
            symbol: 'EGP ',
            decimalDigits: 2,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(details?.worker.name ?? 'تفاصيل العامل'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'الملخص'),
                  Tab(text: 'الإنتاج'),
                  Tab(text: 'السلف'),
                ],
              ),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : details == null
                ? Center(
                    child: Text(state.errorMessage ?? 'تعذر تحميل البيانات'),
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
                              'تاريخ التسجيل: ${DateFormat.yMd().format(details.worker.createdAt)}',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'السعر الحالي لكل 100,000 غرزة: ${currency.format(details.summary.appliedRate)}',
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
    await context.read<WorkerDetailsCubit>().addAdvance(
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
    final summary = state.details!.summary;
    final items = <({String label, String value})>[
      (
        label: 'إجمالي الغرز',
        value: NumberFormat.decimalPattern().format(summary.totalStitchCount),
      ),
      (label: 'الأرباح', value: currency.format(summary.totalEarnings)),
      (label: 'السلف', value: currency.format(summary.totalAdvances)),
      (label: 'الترحيل', value: currency.format(summary.carryOver)),
      (label: 'أيام الغياب', value: summary.absentDays.toString()),
      (label: 'الصافي', value: currency.format(summary.netSalary)),
    ];

    return GridView.builder(
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
                Text(item.value, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        );
      },
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
      return const Center(child: Text('لا توجد سجلات إنتاج لهذا الشهر'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: productions.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = productions[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            title: Text(DateFormat.yMd().format(item.date)),
            subtitle: Text(
              'الغرز: ${NumberFormat.decimalPattern().format(item.stitchCount)}\n'
              'الأرباح: ${currency.format(item.dailyEarnings)}'
              '${item.notes == null ? '' : '\n${item.notes}'}',
            ),
            isThreeLine: item.notes != null,
            trailing: Row(
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
                    await context.read<WorkerDetailsCubit>().saveProduction(
                      productionId: item.id,
                      date: result.date,
                      stitchCount: result.stitchCount,
                      notes: result.notes,
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: () => context
                      .read<WorkerDetailsCubit>()
                      .deleteProduction(item.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        );
      },
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
      return const Center(child: Text('لا توجد سلف لهذا الشهر'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: advances.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = advances[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            title: Text(currency.format(item.amount)),
            subtitle: Text(
              '${DateFormat.yMd().format(item.date)}'
              '${item.notes == null ? '' : '\n${item.notes}'}',
            ),
            trailing: item.carriedOver
                ? const Chip(label: Text('ترحيل'))
                : IconButton(
                    onPressed: () => context
                        .read<WorkerDetailsCubit>()
                        .deleteAdvance(item.id),
                    icon: const Icon(Icons.delete_outline),
                  ),
          ),
        );
      },
    );
  }
}

class _DetailsFab extends StatelessWidget {
  const _DetailsFab({
    required this.onAddProduction,
    required this.onAddAdvance,
    required this.onAbsentDays,
  });

  final VoidCallback onAddProduction;
  final VoidCallback onAddAdvance;
  final VoidCallback onAbsentDays;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.add),
      onSelected: (callback) => callback(),
      itemBuilder: (context) => [
        PopupMenuItem<VoidCallback>(
          value: onAddProduction,
          child: const Text('إضافة إنتاج'),
        ),
        PopupMenuItem<VoidCallback>(
          value: onAddAdvance,
          child: const Text('إضافة سلفة'),
        ),
        PopupMenuItem<VoidCallback>(
          value: onAbsentDays,
          child: const Text('أيام الغياب'),
        ),
      ],
    );
  }
}
