import 'package:go_router/go_router.dart';

import '../../features/clients/presentation/pages/clients_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/threads/presentation/pages/threads_page.dart';
import '../../features/women_staff/presentation/pages/women_staff_page.dart';
import '../../features/workers/presentation/pages/workers_page.dart';
import 'app_shell.dart';

class AppRouter {
  AppRouter()
    : router = GoRouter(
        initialLocation: DashboardPage.routePath,
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) =>
                AppShell(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: DashboardPage.routePath,
                    name: DashboardPage.routeName,
                    builder: (context, state) => const DashboardPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: WorkersPage.routePath,
                    name: WorkersPage.routeName,
                    builder: (context, state) => const WorkersPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: WomenStaffPage.routePath,
                    name: WomenStaffPage.routeName,
                    builder: (context, state) => const WomenStaffPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: ThreadsPage.routePath,
                    name: ThreadsPage.routeName,
                    builder: (context, state) => const ThreadsPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: ClientsPage.routePath,
                    name: ClientsPage.routeName,
                    builder: (context, state) => const ClientsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  final GoRouter router;
}
