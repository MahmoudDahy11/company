import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/client_details_cubit.dart';
import 'client_details_shell.dart';

class ClientDetailsPage extends StatelessWidget {
  const ClientDetailsPage({super.key, required this.clientId});

  static const String routeName = 'client-details';
  static const String routePath = 'details/:clientId';

  final int clientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ClientDetailsCubit>()..init(clientId),
      child: const ClientDetailsShell(),
    );
  }
}
