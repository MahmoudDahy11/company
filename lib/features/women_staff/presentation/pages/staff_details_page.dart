import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/staff_details_cubit.dart';
import '../bloc/staff_details_state.dart';
import '../widgets/staff_detail_actions.dart';
import '../widgets/staff_summary_section.dart';
import '../widgets/staff_transaction_lists.dart';

class StaffDetailsPage extends StatelessWidget {
  const StaffDetailsPage({super.key, required this.staffId});
  static const String routeName = 'staff-details';
  static const String routePath = 'details/:staffId';
  final int staffId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<StaffDetailsCubit>()..init(staffId),
      child: const _StaffDetailsView(),
    );
  }
}

class _StaffDetailsView extends StatelessWidget {
  const _StaffDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffDetailsCubit, StaffDetailsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final details = state.details;
        final currency = NumberFormat.currency(
          locale: Localizations.localeOf(context).toLanguageTag(),
          symbol: 'EGP ', decimalDigits: 2,
        );

        return Scaffold(
          appBar: AppBar(title: Text(details?.staffMember.name ?? l10n.staffDetailsTitle)),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : details == null
              ? Center(child: Text(state.errorMessage ?? l10n.failedToLoadData))
              : RefreshIndicator(
                  onRefresh: () => context.read<StaffDetailsCubit>().refresh(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MonthSelector(
                          month: state.selectedMonth,
                          onPrevious: context.read<StaffDetailsCubit>().previousMonth,
                          onNext: context.read<StaffDetailsCubit>().nextMonth,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(l10n.registrationDate(DateFormat.yMd().format(details.staffMember.createdAt))),
                        const SizedBox(height: AppSpacing.lg),
                        StaffSummarySection(summary: details.summary, currency: currency),
                        const SizedBox(height: AppSpacing.lg),
                        StaffDetailActions(currentSalary: details.staffMember.monthlySalary),
                        const SizedBox(height: AppSpacing.lg),
                        if (details.advances.isEmpty && details.deductions.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                              child: Text(l10n.noData),
                            ),
                          )
                        else ...[
                          if (details.advances.isNotEmpty)
                            AdvancesList(advances: details.advances, currency: currency),
                          if (details.advances.isNotEmpty && details.deductions.isNotEmpty)
                            const SizedBox(height: AppSpacing.lg),
                          if (details.deductions.isNotEmpty)
                            DeductionsList(deductions: details.deductions, currency: currency),
                        ],
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
