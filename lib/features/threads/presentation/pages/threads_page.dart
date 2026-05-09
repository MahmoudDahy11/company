import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/threads_cubit.dart';
import 'threads_view.dart';

class ThreadsPage extends StatelessWidget {
  const ThreadsPage({super.key});

  static const String routeName = 'threads';
  static const String routePath = '/threads';
  static String detailsPath(int supplierId) => '$routePath/details/$supplierId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ThreadsCubit>()..start(),
      child: const ThreadsView(),
    );
  }
}
