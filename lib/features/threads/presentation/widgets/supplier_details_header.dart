import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../../domain/entities/supplier_details_data.dart';
import '../bloc/supplier_details_cubit.dart';
import '../bloc/supplier_details_state.dart';

class SupplierDetailsHeader extends StatelessWidget {
  const SupplierDetailsHeader({
    super.key,
    required this.state,
    required this.details,
    required this.currency,
    required this.l10n,
  });

  final SupplierDetailsState state;
  final SupplierDetailsData details;
  final NumberFormat currency;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonthSelector(
            month: state.selectedMonth,
            onPrevious: context.read<SupplierDetailsCubit>().previousMonth,
            onNext: context.read<SupplierDetailsCubit>().nextMonth,
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
              currency.format(details.summary.outstandingBalance),
            ),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
