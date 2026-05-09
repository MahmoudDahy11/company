import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/clients_cubit.dart';
import 'clients_page_body.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  static const String routeName = 'clients';
  static const String routePath = '/clients';
  static String detailsPath(int clientId) => '$routePath/details/$clientId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ClientsCubit>()..start(),
      child: const ClientsPageBody(),
    );
  }
}
