import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/clients_cubit.dart';
import '../bloc/clients_state.dart';
import '../widgets/clients_list_header.dart';
import '../widgets/clients_list_table.dart';

class ClientsPageBody extends StatelessWidget {
  const ClientsPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsCubit, ClientsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<ClientsCubit>().start(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ClientsListHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.filteredItems.isEmpty)
                      Center(child: Text(l10n.noClientsYet))
                    else
                      ClientsListTable(items: state.filteredItems),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
