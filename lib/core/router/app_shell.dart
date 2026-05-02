import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_controller.dart';
import '../localization/app_locale_controller.dart';
import '../localization/generated/app_localizations.dart';
import '../sync/sync_status_button.dart';
import '../utils/app_breakpoints.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeController = GetIt.I<AppLocaleController>();
    final authController = GetIt.I<AuthController>();
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.dashboard_outlined),
        label: l10n.dashboard,
      ),
      NavigationDestination(
        icon: const Icon(Icons.construction_outlined),
        label: l10n.workers,
      ),
      NavigationDestination(
        icon: const Icon(Icons.group_outlined),
        label: l10n.womenStaff,
      ),
      NavigationDestination(
        icon: const Icon(Icons.inventory_2_outlined),
        label: l10n.threads,
      ),
      NavigationDestination(
        icon: const Icon(Icons.handshake_outlined),
        label: l10n.clients,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onTap,
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: destination.icon,
                          label: Text(destination.label),
                        ),
                      )
                      .toList(),
                  trailing: _ShellActions(localeController: localeController),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.appName),
            actions: [
              _ShellActionButton(
                iconWidget: const SyncStatusButton(),
                tooltip: '',
                onPressed: null,
              ),
              _ShellActionButton(
                icon: Icons.translate,
                tooltip: l10n.switchLanguage,
                onPressed: localeController.toggleLocale,
              ),
              _ShellActionButton(
                icon: Icons.dark_mode_outlined,
                tooltip: l10n.switchTheme,
                onPressed: localeController.toggleTheme,
              ),
              _ShellActionButton(
                icon: Icons.logout,
                tooltip: l10n.signOut,
                onPressed: () => authController.signOut(),
              ),
            ],
          ),
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            destinations: destinations,
            onDestinationSelected: _onTap,
          ),
        );
      },
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _ShellActions extends StatelessWidget {
  const _ShellActions({required this.localeController});

  final AppLocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authController = GetIt.I<AuthController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SyncStatusButton(),
          const SizedBox(height: 8),
          _ShellActionButton(
            icon: Icons.translate,
            tooltip: l10n.switchLanguage,
            onPressed: localeController.toggleLocale,
          ),
          const SizedBox(height: 8),
          _ShellActionButton(
            icon: Icons.dark_mode_outlined,
            tooltip: l10n.switchTheme,
            onPressed: localeController.toggleTheme,
          ),
          const SizedBox(height: 8),
          _ShellActionButton(
            icon: Icons.logout,
            tooltip: l10n.signOut,
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
    );
  }
}

class _ShellActionButton extends StatelessWidget {
  const _ShellActionButton({
    this.icon,
    this.tooltip,
    this.onPressed,
    this.iconWidget,
  });

  final IconData? icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    if (iconWidget != null) {
      return iconWidget!;
    }

    return IconButton(onPressed: onPressed, tooltip: tooltip, icon: Icon(icon));
  }
}
