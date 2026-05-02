import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/client_details_cubit.dart';
import '../bloc/client_details_state.dart';
import '../widgets/clients_forms.dart';

class ClientDetailsPage extends StatelessWidget {
  const ClientDetailsPage({super.key, required this.clientId});

  static const String routeName = 'client-details';
  static const String routePath = 'details/:clientId';

  final int clientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ClientDetailsCubit>()..init(clientId),
      child: const _ClientDetailsView(),
    );
  }
}

class _ClientDetailsView extends StatelessWidget {
  const _ClientDetailsView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocBuilder<ClientDetailsCubit, ClientDetailsState>(
        builder: (context, state) {
          final details = state.details;
          final currency = NumberFormat.currency(
            locale: Localizations.localeOf(context).toLanguageTag(),
            symbol: 'EGP ',
            decimalDigits: 2,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(details?.client.name ?? 'تفاصيل الزبون'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'الموديلات'),
                  Tab(text: 'المدفوعات'),
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
                                  .read<ClientDetailsCubit>()
                                  .previousMonth,
                              onNext: context
                                  .read<ClientDetailsCubit>()
                                  .nextMonth,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              details.client.phone == null
                                  ? 'لا يوجد رقم هاتف'
                                  : 'الهاتف: ${details.client.phone}',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'المتبقي: ${currency.format(details.summary.outstanding)}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _ModelsTab(currency: currency),
                            _PaymentsTab(currency: currency),
                          ],
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: PopupMenuButton<VoidCallback>(
              icon: const Icon(Icons.add),
              onSelected: (action) => action(),
              itemBuilder: (context) => [
                PopupMenuItem<VoidCallback>(
                  value: () async {
                    final result = await showClientModelSheet(context);
                    if (result != null && context.mounted) {
                      await context.read<ClientDetailsCubit>().addModel(
                        modelName: result.modelName,
                        pieceCount: result.pieceCount,
                        pricePerPiece: result.pricePerPiece,
                        date: result.date,
                        notes: result.notes,
                      );
                    }
                  },
                  child: const Text('إضافة موديل'),
                ),
                PopupMenuItem<VoidCallback>(
                  value: () async {
                    final result = await showClientPaymentSheet(context);
                    if (result != null && context.mounted) {
                      await context.read<ClientDetailsCubit>().addPayment(
                        amount: result.amount,
                        paymentDate: result.paymentDate,
                        notes: result.notes,
                      );
                    }
                  },
                  child: const Text('إضافة دفعة'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ModelsTab extends StatelessWidget {
  const _ModelsTab({required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final details = context.select(
      (ClientDetailsCubit cubit) => cubit.state.details,
    );
    final models = details?.models ?? const [];
    if (models.isEmpty) {
      return const Center(child: Text('لا توجد موديلات لهذا الشهر'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: models.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = models[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            title: Text(item.modelName),
            subtitle: Text(
              '${DateFormat.yMd().format(item.date)}\n'
              '${item.pieceCount} قطعة • ${currency.format(item.pricePerPiece)}\n'
              'الإجمالي: ${currency.format(item.total)}'
              '${item.notes == null ? '' : '\n${item.notes}'}',
            ),
            trailing: IconButton(
              onPressed: () =>
                  context.read<ClientDetailsCubit>().deleteModel(item.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        );
      },
    );
  }
}

class _PaymentsTab extends StatelessWidget {
  const _PaymentsTab({required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final details = context.select(
      (ClientDetailsCubit cubit) => cubit.state.details,
    );
    final payments = details?.payments ?? const [];
    if (payments.isEmpty) {
      return const Center(child: Text('لا توجد دفعات لهذا الشهر'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: payments.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = payments[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            title: Text(currency.format(item.amount)),
            subtitle: Text(
              '${DateFormat.yMd().format(item.paymentDate)}'
              '${item.notes == null ? '' : '\n${item.notes}'}',
            ),
            trailing: IconButton(
              onPressed: () =>
                  context.read<ClientDetailsCubit>().deletePayment(item.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        );
      },
    );
  }
}
