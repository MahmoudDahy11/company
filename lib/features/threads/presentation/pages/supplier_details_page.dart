import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../domain/entities/supplier_details_data.dart';
import '../bloc/supplier_details_cubit.dart';
import '../bloc/supplier_details_state.dart';
import '../widgets/purchase_form_sheet.dart';
import '../widgets/payment_form_sheet.dart';
import '../widgets/supplier_details_header.dart';
import '../widgets/supplier_details_purchases_tab.dart';
import '../widgets/supplier_details_payments_tab.dart';

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
                : _content(context, state, details, currency, l10n),
            floatingActionButton: _fab(context, l10n),
          );
        },
      ),
    );
  }

  Widget _content(
    BuildContext context,
    SupplierDetailsState state,
    SupplierDetailsData details,
    NumberFormat currency,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        SupplierDetailsHeader(
          state: state,
          details: details,
          currency: currency,
          l10n: l10n,
        ),
        Expanded(
          child: TabBarView(
            children: [
              SupplierDetailsPurchasesTab(currency: currency),
              SupplierDetailsPaymentsTab(currency: currency),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fab(BuildContext context, AppLocalizations l10n) {
    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.add),
      onSelected: (a) => a(),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: () => _addPurchase(context),
          child: Text(l10n.addPurchase),
        ),
        PopupMenuItem(
          value: () => _addPayment(context),
          child: Text(l10n.addPayment),
        ),
      ],
    );
  }

  Future<void> _addPurchase(BuildContext context) async {
    final r = await showPurchaseSheet(context);
    if (r != null && context.mounted) {
      await context.read<SupplierDetailsCubit>().savePurchase(
        itemName: r.itemName,
        colorNumber: r.colorNumber,
        purchaseDate: r.purchaseDate,
        price: r.price,
        quantity: r.quantity,
        unit: r.unit,
        notes: r.notes,
      );
    }
  }

  Future<void> _addPayment(BuildContext context) async {
    final r = await showSupplierPaymentSheet(context);
    if (r != null && context.mounted) {
      await context.read<SupplierDetailsCubit>().savePayment(
        amount: r.amount,
        paymentDate: r.paymentDate,
        notes: r.notes,
      );
    }
  }
}
