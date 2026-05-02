import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'core/localization/app_locale_controller.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class FactoryApp extends StatelessWidget {
  const FactoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = GetIt.I<AppLocaleController>();
    final router = GetIt.I<AppRouter>().router;

    return ValueListenableBuilder<Locale>(
      valueListenable: localeController.localeNotifier,
      builder: (context, locale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: localeController.themeModeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Factory System',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: themeMode,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              routerConfig: router,
              builder: (context, child) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}
