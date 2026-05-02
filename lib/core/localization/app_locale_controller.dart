import 'package:flutter/material.dart';

class AppLocaleController {
  AppLocaleController()
    : localeNotifier = ValueNotifier(const Locale('ar')),
      themeModeNotifier = ValueNotifier(ThemeMode.light);

  final ValueNotifier<Locale> localeNotifier;
  final ValueNotifier<ThemeMode> themeModeNotifier;

  void toggleLocale() {
    localeNotifier.value = localeNotifier.value.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
  }

  void toggleTheme() {
    themeModeNotifier.value = themeModeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
