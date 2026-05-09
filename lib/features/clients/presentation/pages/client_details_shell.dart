import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/client_details_cubit.dart';
import '../bloc/client_details_state.dart';
import '../widgets/client_details_fab.dart';
import 'client_models_tab.dart';
import 'client_payments_tab.dart';

class ClientDetailsShell extends StatelessWidget {
  const ClientDetailsShell({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocBuilder<ClientDetailsCubit, ClientDetailsState>(
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
              title: Text(details?.client.name ?? l10n.clientDetailsTitle),
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.modelsTab),
                  Tab(text: l10n.paymentsTab),
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
                                  .read<ClientDetailsCubit>()
                                  .previousMonth,
                              onNext: context
                                  .read<ClientDetailsCubit>()
                                  .nextMonth,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              details.client.phone == null
                                  ? l10n.noPhoneNumber
                                  : l10n.phone(details.client.phone!),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.outstanding(
                                currency.format(details.summary.outstanding),
                              ),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ClientModelsTab(currency: currency),
                            ClientPaymentsTab(currency: currency),
                          ],
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: const ClientDetailsFab(),
          );
        },
      ),
    );
  }
}
