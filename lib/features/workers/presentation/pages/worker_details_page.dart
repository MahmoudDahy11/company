import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../bloc/worker_details_cubit.dart';
import '../bloc/worker_details_state.dart';
import '../widgets/worker_advances_tab.dart';
import '../widgets/worker_deductions_tab.dart';
import '../widgets/worker_details_fab.dart';
import '../widgets/worker_details_header.dart';
import '../widgets/worker_production_tab.dart';
import '../widgets/worker_summary_tab.dart';
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
                      WorkerDetailsHeader(
                        selectedMonth: state.selectedMonth,
                        details: details,
                        currency: currency,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            WorkerSummaryTab(state: state, currency: currency),
                            WorkerProductionTab(
                              productions: details.productions,
                              currency: currency,
                            ),
                            WorkerAdvancesTab(
                              advances: details.advances,
                              currency: currency,
                            ),
                            WorkerDeductionsTab(
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
                : WorkerDetailsFab(
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
    if (result == null || !context.mounted) return;
    await context.read<WorkerDetailsCubit>().saveProduction(
      date: result.date,
      stitchCount: result.stitchCount,
      notes: result.notes,
    );
  }

  Future<void> _onAddAdvance(BuildContext context) async {
    final result = await showAdvanceSheet(context);
    if (result == null || !context.mounted) return;
    await context.read<WorkerDetailsCubit>().saveAdvance(
      advanceId: result.advanceId,
      amount: result.amount,
      date: result.date,
      notes: result.notes,
    );
  }

  Future<void> _onAddDeduction(BuildContext context) async {
    final result = await showDeductionSheet(context);
    if (result == null || !context.mounted) return;
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
    if (result == null || !context.mounted) return;
    await context.read<WorkerDetailsCubit>().saveAbsentDays(result);
  }
}
