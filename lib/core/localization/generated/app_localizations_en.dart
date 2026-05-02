// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Factory System';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get workers => 'Workers';

  @override
  String get womenStaff => 'Women Staff';

  @override
  String get threads => 'Threads';

  @override
  String get clients => 'Clients';

  @override
  String get setupReadyTitle => 'Project setup is ready';

  @override
  String get setupReadyDescription =>
      'Core architecture, routing, localization, and app foundations are now in place.';

  @override
  String get switchLanguage => 'Switch language';

  @override
  String get switchTheme => 'Switch theme';

  @override
  String get syncSynced => 'All data is synced';

  @override
  String get syncInProgress => 'Sync in progress';

  @override
  String get syncPending => 'Pending sync items';

  @override
  String get syncFailed => 'Failed sync items';

  @override
  String get syncStatusTitle => 'Sync status';

  @override
  String get pendingItems => 'Pending items';

  @override
  String get failedItems => 'Failed items';

  @override
  String get retrySync => 'Retry sync';

  @override
  String get noSyncItems => 'There are no pending or failed sync items.';

  @override
  String featureComingSoon(Object feature) {
    return '$feature is ready for implementation.';
  }
}
