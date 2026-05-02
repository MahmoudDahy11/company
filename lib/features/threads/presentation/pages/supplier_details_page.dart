import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/supplier_details_cubit.dart';
import '../bloc/supplier_details_state.dart';
import '../widgets/threads_forms.dart';

class SupplierDetailsPage extends StatelessWidget {
  const SupplierDetailsPage({super.key, required this.supplierId});

  static const String routeName = 'supplier-details';
  static const String routePath = 'details/:supplierId';

  final int supplierId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<SupplierDetailsCubit>()..init(supplierId),
      child: const _SupplierDetailsView(),
    );
  }
}

class _SupplierDetailsView extends StatelessWidget {
  const _SupplierDetailsView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocBuilder<SupplierDetailsCubit, SupplierDetailsState>(
        builder: (context, state) {
          final details = state.details;
          final currency = NumberFormat.currency(
            locale: Localizations.localeOf(context).toLanguageTag(),
            symbol: 'EGP ',
            decimalDigits: 2,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(details?.supplier.name ?? 'تفاصيل المورد'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'المشتريات'),
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
                                  .read<SupplierDetailsCubit>()
                                  .previousMonth,
                              onNext: context
                                  .read<SupplierDetailsCubit>()
                                  .nextMonth,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              details.supplier.phone == null
                                  ? 'لا يوجد رقم هاتف'
                                  : 'الهاتف: ${details.supplier.phone}',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'المتبقي: ${currency.format(details.summary.outstandingBalance)}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _PurchasesTab(currency: currency),
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
                    final result = await showPurchaseSheet(context);
                    if (result != null && context.mounted) {
                      await context.read<SupplierDetailsCubit>().addPurchase(
                        itemName: result.itemName,
                        colorNumber: result.colorNumber,
                        purchaseDate: result.purchaseDate,
                        price: result.price,
                        quantity: result.quantity,
                        unit: result.unit,
                        notes: result.notes,
                      );
                    }
                  },
                  child: const Text('إضافة شراء'),
                ),
                PopupMenuItem<VoidCallback>(
                  value: () async {
                    final result = await showSupplierPaymentSheet(context);
                    if (result != null && context.mounted) {
                      await context.read<SupplierDetailsCubit>().addPayment(
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

class _PurchasesTab extends StatelessWidget {
  const _PurchasesTab({required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final details = context.select(
      (SupplierDetailsCubit cubit) => cubit.state.details,
    );
    final purchases = details?.purchases ?? const [];
    if (purchases.isEmpty) {
      return const Center(child: Text('لا توجد مشتريات لهذا الشهر'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: purchases.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = purchases[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            title: Text('${item.itemName} • ${item.colorNumber}'),
            subtitle: Text(
              '${DateFormat.yMd().format(item.purchaseDate)}\n'
              '${currency.format(item.price)} • ${item.quantity} ${item.unit}'
              '${item.notes == null ? '' : '\n${item.notes}'}',
            ),
            trailing: IconButton(
              onPressed: () =>
                  context.read<SupplierDetailsCubit>().deletePurchase(item.id),
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
      (SupplierDetailsCubit cubit) => cubit.state.details,
    );
    final payments = details?.payments ?? const [];
    if (payments.isEmpty) {
      return const Center(child: Text('لا توجد مدفوعات لهذا الشهر'));
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
                  context.read<SupplierDetailsCubit>().deletePayment(item.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        );
      },
    );
  }
}
