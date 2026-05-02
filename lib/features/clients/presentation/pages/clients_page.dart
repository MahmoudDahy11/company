import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/clients_cubit.dart';
import '../bloc/clients_state.dart';
import '../widgets/client_summary_card.dart';
import '../widgets/clients_forms.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  static const String routeName = 'clients';
  static const String routePath = '/clients';
  static String detailsPath(int clientId) => '$routePath/details/$clientId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ClientsCubit>()..start(),
      child: const _ClientsView(),
    );
  }
}

class _ClientsView extends StatelessWidget {
  const _ClientsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsCubit, ClientsState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الزبايين',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 320,
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'ابحث عن زبون',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: context
                              .read<ClientsCubit>()
                              .updateSearchQuery,
                        ),
                      ),
                      MonthSelector(
                        month: state.selectedMonth,
                        onPrevious: context.read<ClientsCubit>().previousMonth,
                        onNext: context.read<ClientsCubit>().nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.filteredItems.isEmpty
                        ? const Center(child: Text('لا يوجد زباين حتى الآن'))
                        : ListView.separated(
                            itemCount: state.filteredItems.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final item = state.filteredItems[index];
                              return ClientSummaryCard(
                                item: item,
                                onTap: () => context.push(
                                  ClientsPage.detailsPath(item.id),
                                ),
                                onDelete: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('حذف الزبون'),
                                      content: Text(
                                        'هل تريد حذف ${item.name}؟',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('إلغاء'),
                                        ),
                                        FilledButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('حذف'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (shouldDelete == true && context.mounted) {
                                    await context
                                        .read<ClientsCubit>()
                                        .deleteClient(item.id);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await showClientSheet(context);
              if (result != null && context.mounted) {
                await context.read<ClientsCubit>().addClient(
                  name: result.name,
                  phone: result.phone,
                );
              }
            },
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: const Text('إضافة زبون'),
          ),
        );
      },
    );
  }
}
