import 'package:company/core/localization/app_locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('locale controller toggles between Arabic and English', () {
    final controller = AppLocaleController();

    expect(controller.localeNotifier.value, const Locale('ar'));

    controller.toggleLocale();
    expect(controller.localeNotifier.value, const Locale('en'));

    controller.toggleLocale();
    expect(controller.localeNotifier.value, const Locale('ar'));
  });
}
