import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/workers_cubit.dart';
import '../bloc/workers_state.dart';
import '../widgets/workers_action_bar.dart';
import '../widgets/workers_data_table.dart';
import '../widgets/workers_header.dart';

class WorkersPage extends StatelessWidget {
  const WorkersPage({super.key});

  static const String routeName = 'workers';
  static const String routePath = '/workers';
  static String detailsPath(int workerId) => '$routePath/details/$workerId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<WorkersCubit>()..start(),
      child: const _WorkersView(),
    );
  }
}

class _WorkersView extends StatelessWidget {
  const _WorkersView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkersCubit, WorkersState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<WorkersCubit>().start(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WorkersActionBar(),
                    const SizedBox(height: AppSpacing.lg),
                    const WorkersHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.filteredItems.isEmpty
                        ? Center(child: Text(l10n.noWorkersYet))
                        : const WorkersDataTable(),
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
