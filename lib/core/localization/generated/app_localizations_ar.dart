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
  String get syncSynced => 'كل البيانات متزامنة';

  @override
  String get syncInProgress => 'المزامنة قيد التنفيذ';

  @override
  String get syncPending => 'هناك عناصر تنتظر المزامنة';

  @override
  String get syncFailed => 'هناك عناصر فشل تزامنها';

  @override
  String get syncStatusTitle => 'حالة المزامنة';

  @override
  String get pendingItems => 'العناصر المعلقة';

  @override
  String get failedItems => 'العناصر الفاشلة';

  @override
  String get retrySync => 'إعادة المحاولة';

  @override
  String get noSyncItems => 'لا توجد عناصر معلقة أو فاشلة للمزامنة.';

  @override
  String featureComingSoon(Object feature) {
    return '$feature جاهز للتنفيذ.';
  }
}
