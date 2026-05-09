import 'package:injectable/injectable.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/clients/presentation/pages/client_details_page.dart';
import '../../features/clients/presentation/pages/clients_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/threads/presentation/pages/supplier_details_page.dart';
import '../../features/threads/presentation/pages/threads_page.dart';
import '../../features/women_staff/presentation/pages/staff_details_page.dart';
import '../../features/women_staff/presentation/pages/women_staff_page.dart';
import '../../features/workers/presentation/pages/worker_details_page.dart';
import '../../features/maintenance/presentation/pages/maintenance_fault_records_page.dart';
import '../../features/workers/presentation/pages/workers_page.dart';
import '../auth/auth_controller.dart';
import 'app_shell.dart';

@lazySingleton
class AppRouter {
  AppRouter(AuthController authController)
    : router = GoRouter(
        refreshListenable: authController,
        redirect: (context, state) {
          final isAuthenticated = authController.isAuthenticated;
          final isLoginRoute = state.matchedLocation == LoginPage.routePath;

          if (!isAuthenticated && !isLoginRoute) {
            return LoginPage.routePath;
          }

          if (isAuthenticated && isLoginRoute) {
            return DashboardPage.routePath;
          }

          return null;
        },
        initialLocation: DashboardPage.routePath,
        routes: [
          GoRoute(
            path: LoginPage.routePath,
            name: LoginPage.routeName,
            builder: (context, state) => const LoginPage(),
          ),
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
                    routes: [
                      GoRoute(
                        path: WorkerDetailsPage.routePath,
                        name: WorkerDetailsPage.routeName,
                        builder: (context, state) {
                          final workerId = int.parse(
                            state.pathParameters['workerId']!,
                          );
                          return WorkerDetailsPage(workerId: workerId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: WomenStaffPage.routePath,
                    name: WomenStaffPage.routeName,
                    builder: (context, state) => const WomenStaffPage(),
                    routes: [
                      GoRoute(
                        path: StaffDetailsPage.routePath,
                        name: StaffDetailsPage.routeName,
                        builder: (context, state) {
                          final staffId = int.parse(
                            state.pathParameters['staffId']!,
                          );
                          return StaffDetailsPage(staffId: staffId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: ThreadsPage.routePath,
                    name: ThreadsPage.routeName,
                    builder: (context, state) => const ThreadsPage(),
                    routes: [
                      GoRoute(
                        path: SupplierDetailsPage.routePath,
                        name: SupplierDetailsPage.routeName,
                        builder: (context, state) {
                          final supplierId = int.parse(
                            state.pathParameters['supplierId']!,
                          );
                          return SupplierDetailsPage(supplierId: supplierId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: ClientsPage.routePath,
                    name: ClientsPage.routeName,
                    builder: (context, state) => const ClientsPage(),
                    routes: [
                      GoRoute(
                        path: ClientDetailsPage.routePath,
                        name: ClientDetailsPage.routeName,
                        builder: (context, state) {
                          final clientId = int.parse(
                            state.pathParameters['clientId']!,
                          );
                          return ClientDetailsPage(clientId: clientId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: MaintenanceFaultRecordsPage.routePath,
                    name: MaintenanceFaultRecordsPage.routeName,
                    builder: (context, state) =>
                        const MaintenanceFaultRecordsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  final GoRouter router;
}
