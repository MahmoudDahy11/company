import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/threads_cubit.dart';
import '../bloc/threads_state.dart';
import '../widgets/threads_header_widget.dart';
import '../widgets/threads_supplier_table.dart';

class ThreadsView extends StatelessWidget {
  const ThreadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThreadsCubit, ThreadsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<ThreadsCubit>().start(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ThreadsHeaderWidget(
                      items: state.items,
                      allPurchases: state.allPurchases,
                      selectedMonth: state.selectedMonth,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildContent(context, state, l10n),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThreadsState state,
    AppLocalizations l10n,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.filteredItems.isEmpty) {
      return Center(child: Text(l10n.noSuppliersYet));
    }
    return ThreadsSupplierTable(items: state.filteredItems);
  }
}
