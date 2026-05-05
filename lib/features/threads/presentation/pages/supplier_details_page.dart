import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
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
          final l10n = AppLocalizations.of(context)!;
          final details = state.details;
          final currency = NumberFormat.currency(
            locale: Localizations.localeOf(context).toLanguageTag(),
            symbol: 'EGP ',
            decimalDigits: 2,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(details?.supplier.name ?? l10n.supplierDetailsTitle),
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.purchasesTab),
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
                                  .read<SupplierDetailsCubit>()
                                  .previousMonth,
                              onNext: context
                                  .read<SupplierDetailsCubit>()
                                  .nextMonth,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              details.supplier.phone == null
                                  ? l10n.noPhoneNumber
                                  : l10n.phone(details.supplier.phone!),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.outstanding(
                                currency.format(
                                  details.summary.outstandingBalance,
                                ),
                              ),
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
                  child: Text(l10n.addPurchase),
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
                  child: Text(l10n.addPayment),
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
      return RefreshIndicator(
        onRefresh: () => context.read<SupplierDetailsCubit>().refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Text(AppLocalizations.of(context)!.noPurchasesThisMonth),
            ),
          ),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () => context.read<SupplierDetailsCubit>().refresh(),
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
                DataColumn(label: Text(l10n.itemType)),
                DataColumn(label: Text(l10n.colorNumber)),
                DataColumn(label: Text(l10n.price)),
                DataColumn(label: Text(l10n.quantity)),
                DataColumn(label: Text(l10n.notes)),
                DataColumn(label: Text(l10n.actions)),
              ],
              rows: purchases.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(DateFormat.yMd().format(item.purchaseDate))),
                    DataCell(Text(item.itemName)),
                    DataCell(Text(item.colorNumber)),
                    DataCell(Text(currency.format(item.price))),
                    DataCell(Text('${item.quantity} ${item.unit}')),
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
                              final result = await showPurchaseSheet(
                                context,
                                initialValue: PurchaseFormResult(
                                  purchaseId: item.id,
                                  itemName: item.itemName,
                                  colorNumber: item.colorNumber,
                                  purchaseDate: item.purchaseDate,
                                  price: item.price,
                                  quantity: item.quantity,
                                  unit: item.unit,
                                  notes: item.notes,
                                ),
                              );
                              if (result != null && context.mounted) {
                                await context
                                    .read<SupplierDetailsCubit>()
                                    .updatePurchase(
                                      purchaseId: item.id,
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
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.deletePurchaseTitle),
                                  content: Text(l10n.confirmDeletePurchase),
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
                                    .read<SupplierDetailsCubit>()
                                    .deletePurchase(item.id);
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
      return RefreshIndicator(
        onRefresh: () => context.read<SupplierDetailsCubit>().refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Text(AppLocalizations.of(context)!.noPaymentsThisMonth),
            ),
          ),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () => context.read<SupplierDetailsCubit>().refresh(),
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
              rows: payments.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(DateFormat.yMd().format(item.paymentDate))),
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
                              final result = await showSupplierPaymentSheet(
                                context,
                                initialValue: SupplierPaymentFormResult(
                                  paymentId: item.id,
                                  amount: item.amount,
                                  paymentDate: item.paymentDate,
                                  notes: item.notes,
                                ),
                              );
                              if (result != null && context.mounted) {
                                await context
                                    .read<SupplierDetailsCubit>()
                                    .updatePayment(
                                      paymentId: item.id,
                                      amount: result.amount,
                                      paymentDate: result.paymentDate,
                                      notes: result.notes,
                                    );
                              }
                            },
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.deletePaymentTitle),
                                  content: Text(
                                    l10n.confirmDeletePayment(
                                      currency.format(item.amount),
                                    ),
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
                                    .read<SupplierDetailsCubit>()
                                    .deletePayment(item.id);
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
