import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import 'dashboard_header.dart';
import 'dashboard_cards_section.dart';
import 'charts_section.dart';
import 'financial_section.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final summary = state.summary;
        final currency = NumberFormat.currency(
          locale: Localizations.localeOf(context).toLanguageTag(),
          symbol: 'EGP ',
          decimalDigits: 2,
        );

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().start(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(
                    month: state.selectedMonth,
                    onMonthChanged: context.read<DashboardCubit>().updateMonth,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (summary == null)
                    Center(
                      child: Text(state.errorMessage ?? l10n.failedToLoadData),
                    )
                  else ...[
                    DashboardCardsSection(summary: summary, currency: currency),
                    const SizedBox(height: AppSpacing.lg),
                    ChartsSection(
                      summary: summary,
                      currency: currency,
                      selectedMonth: state.selectedMonth,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Divider(),
                    const SizedBox(height: AppSpacing.xl),
                    FinancialSection(
                      summary: summary,
                      currency: currency,
                      currentFilter: state.financialFilter,
                      onFilterChanged: context
                          .read<DashboardCubit>()
                          .updateFinancialFilter,
                    ),
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
