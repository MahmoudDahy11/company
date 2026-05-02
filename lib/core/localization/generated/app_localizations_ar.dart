// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'نظام المصنع';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get workers => 'العمال';

  @override
  String get womenStaff => 'الحريم';

  @override
  String get threads => 'الخيوط';

  @override
  String get clients => 'الزبايين';

  @override
  String get setupReadyTitle => 'تم تجهيز إعداد المشروع';

  @override
  String get setupReadyDescription =>
      'أصبحت البنية الأساسية والتنقل والترجمة وتجهيز التطبيق جاهزة.';

  @override
  String get switchLanguage => 'تغيير اللغة';

  @override
  String get switchTheme => 'تغيير الثيم';

  @override
  String featureComingSoon(Object feature) {
    return '$feature جاهز للتنفيذ.';
  }
}
