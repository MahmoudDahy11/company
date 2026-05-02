import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Factory System'**
  String get appName;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @workers.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get workers;

  /// No description provided for @womenStaff.
  ///
  /// In en, this message translates to:
  /// **'Women Staff'**
  String get womenStaff;

  /// No description provided for @threads.
  ///
  /// In en, this message translates to:
  /// **'Threads'**
  String get threads;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @setupReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Project setup is ready'**
  String get setupReadyTitle;

  /// No description provided for @setupReadyDescription.
  ///
  /// In en, this message translates to:
  /// **'Core architecture, routing, localization, and app foundations are now in place.'**
  String get setupReadyDescription;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get switchLanguage;

  /// No description provided for @switchTheme.
  ///
  /// In en, this message translates to:
  /// **'Switch theme'**
  String get switchTheme;

  /// No description provided for @syncSynced.
  ///
  /// In en, this message translates to:
  /// **'All data is synced'**
  String get syncSynced;

  /// No description provided for @syncInProgress.
  ///
  /// In en, this message translates to:
  /// **'Sync in progress'**
  String get syncInProgress;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'Pending sync items'**
  String get syncPending;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed sync items'**
  String get syncFailed;

  /// No description provided for @syncStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get syncStatusTitle;

  /// No description provided for @pendingItems.
  ///
  /// In en, this message translates to:
  /// **'Pending items'**
  String get pendingItems;

  /// No description provided for @failedItems.
  ///
  /// In en, this message translates to:
  /// **'Failed items'**
  String get failedItems;

  /// No description provided for @retrySync.
  ///
  /// In en, this message translates to:
  /// **'Retry sync'**
  String get retrySync;

  /// No description provided for @noSyncItems.
  ///
  /// In en, this message translates to:
  /// **'There are no pending or failed sync items.'**
  String get noSyncItems;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone: {value}'**
  String phone(Object value);

  /// No description provided for @noPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhoneNumber;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get failedToLoadData;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration date: {value}'**
  String registrationDate(Object value);

  /// No description provided for @dashboardSummaryWorkersWages.
  ///
  /// In en, this message translates to:
  /// **'Total worker wages'**
  String get dashboardSummaryWorkersWages;

  /// No description provided for @dashboardSummaryWomenWages.
  ///
  /// In en, this message translates to:
  /// **'Total women staff wages'**
  String get dashboardSummaryWomenWages;

  /// No description provided for @dashboardSummaryThreadPurchases.
  ///
  /// In en, this message translates to:
  /// **'Total thread purchases'**
  String get dashboardSummaryThreadPurchases;

  /// No description provided for @dashboardSummaryClientOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Total client outstanding'**
  String get dashboardSummaryClientOutstanding;

  /// No description provided for @dashboardQuickInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick info'**
  String get dashboardQuickInfoTitle;

  /// No description provided for @dashboardRegisteredWorkers.
  ///
  /// In en, this message translates to:
  /// **'Registered workers'**
  String get dashboardRegisteredWorkers;

  /// No description provided for @dashboardAbsentDaysThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Absent days this month'**
  String get dashboardAbsentDaysThisMonth;

  /// No description provided for @dashboardPendingClients.
  ///
  /// In en, this message translates to:
  /// **'Clients with outstanding balances'**
  String get dashboardPendingClients;

  /// No description provided for @dashboardSuppliersOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Suppliers with outstanding balance'**
  String get dashboardSuppliersOutstanding;

  /// No description provided for @dashboardTopWorkersChart.
  ///
  /// In en, this message translates to:
  /// **'Top 5 workers this month'**
  String get dashboardTopWorkersChart;

  /// No description provided for @dashboardThreadsYearChart.
  ///
  /// In en, this message translates to:
  /// **'Thread purchases over the year'**
  String get dashboardThreadsYearChart;

  /// No description provided for @dashboardClientsDistributionChart.
  ///
  /// In en, this message translates to:
  /// **'Client balance distribution'**
  String get dashboardClientsDistributionChart;

  /// No description provided for @dashboardWomenAdvancesChart.
  ///
  /// In en, this message translates to:
  /// **'Women staff advances this month'**
  String get dashboardWomenAdvancesChart;

  /// No description provided for @noCurrentDebts.
  ///
  /// In en, this message translates to:
  /// **'There are no current debts'**
  String get noCurrentDebts;

  /// No description provided for @workersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search worker'**
  String get workersSearchHint;

  /// No description provided for @stitchRate.
  ///
  /// In en, this message translates to:
  /// **'Stitch rate'**
  String get stitchRate;

  /// No description provided for @noWorkersYet.
  ///
  /// In en, this message translates to:
  /// **'No workers yet'**
  String get noWorkersYet;

  /// No description provided for @deleteWorkerTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete worker'**
  String get deleteWorkerTitle;

  /// No description provided for @confirmDeleteWorker.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String confirmDeleteWorker(Object name);

  /// No description provided for @addWorker.
  ///
  /// In en, this message translates to:
  /// **'Add worker'**
  String get addWorker;

  /// No description provided for @workerDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Worker details'**
  String get workerDetailsTitle;

  /// No description provided for @summaryTab.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTab;

  /// No description provided for @productionTab.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get productionTab;

  /// No description provided for @advancesTab.
  ///
  /// In en, this message translates to:
  /// **'Advances'**
  String get advancesTab;

  /// No description provided for @currentRatePer100k.
  ///
  /// In en, this message translates to:
  /// **'Current rate per 100,000 stitches: {value}'**
  String currentRatePer100k(Object value);

  /// No description provided for @totalStitches.
  ///
  /// In en, this message translates to:
  /// **'Total stitches'**
  String get totalStitches;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @advances.
  ///
  /// In en, this message translates to:
  /// **'Advances'**
  String get advances;

  /// No description provided for @carryOver.
  ///
  /// In en, this message translates to:
  /// **'Carry-over'**
  String get carryOver;

  /// No description provided for @absentDays.
  ///
  /// In en, this message translates to:
  /// **'Absent days'**
  String get absentDays;

  /// No description provided for @netSalary.
  ///
  /// In en, this message translates to:
  /// **'Net salary'**
  String get netSalary;

  /// No description provided for @noProductionThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No production records for this month'**
  String get noProductionThisMonth;

  /// No description provided for @stitchesValue.
  ///
  /// In en, this message translates to:
  /// **'Stitches: {value}'**
  String stitchesValue(Object value);

  /// No description provided for @earningsValue.
  ///
  /// In en, this message translates to:
  /// **'Earnings: {value}'**
  String earningsValue(Object value);

  /// No description provided for @noAdvancesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No advances for this month'**
  String get noAdvancesThisMonth;

  /// No description provided for @addProduction.
  ///
  /// In en, this message translates to:
  /// **'Add production'**
  String get addProduction;

  /// No description provided for @addAdvance.
  ///
  /// In en, this message translates to:
  /// **'Add advance'**
  String get addAdvance;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add payment'**
  String get addPayment;

  /// No description provided for @addPurchase.
  ///
  /// In en, this message translates to:
  /// **'Add purchase'**
  String get addPurchase;

  /// No description provided for @addModel.
  ///
  /// In en, this message translates to:
  /// **'Add model'**
  String get addModel;

  /// No description provided for @workerName.
  ///
  /// In en, this message translates to:
  /// **'Worker name'**
  String get workerName;

  /// No description provided for @updateStitchRate.
  ///
  /// In en, this message translates to:
  /// **'Update stitch rate'**
  String get updateStitchRate;

  /// No description provided for @ratePer100kStitches.
  ///
  /// In en, this message translates to:
  /// **'Rate per 100,000 stitches'**
  String get ratePer100kStitches;

  /// No description provided for @editProduction.
  ///
  /// In en, this message translates to:
  /// **'Edit production'**
  String get editProduction;

  /// No description provided for @stitchCount.
  ///
  /// In en, this message translates to:
  /// **'Stitch count'**
  String get stitchCount;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'Number of days'**
  String get daysCount;

  /// No description provided for @womenStaffSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search staff member'**
  String get womenStaffSearchHint;

  /// No description provided for @noWomenStaffYet.
  ///
  /// In en, this message translates to:
  /// **'No women staff yet'**
  String get noWomenStaffYet;

  /// No description provided for @deleteStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete staff member'**
  String get deleteStaffTitle;

  /// No description provided for @confirmDeleteStaff.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String confirmDeleteStaff(Object name);

  /// No description provided for @addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add staff member'**
  String get addStaff;

  /// No description provided for @staffDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff details'**
  String get staffDetailsTitle;

  /// No description provided for @fixedSalary.
  ///
  /// In en, this message translates to:
  /// **'Fixed salary'**
  String get fixedSalary;

  /// No description provided for @updateSalary.
  ///
  /// In en, this message translates to:
  /// **'Update salary'**
  String get updateSalary;

  /// No description provided for @staffName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get staffName;

  /// No description provided for @monthlySalary.
  ///
  /// In en, this message translates to:
  /// **'Monthly salary'**
  String get monthlySalary;

  /// No description provided for @threadsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search supplier'**
  String get threadsSearchHint;

  /// No description provided for @monthlyPurchases.
  ///
  /// In en, this message translates to:
  /// **'Monthly purchases'**
  String get monthlyPurchases;

  /// No description provided for @yearlyPurchases.
  ///
  /// In en, this message translates to:
  /// **'Yearly purchases'**
  String get yearlyPurchases;

  /// No description provided for @yearlyPayments.
  ///
  /// In en, this message translates to:
  /// **'Yearly payments'**
  String get yearlyPayments;

  /// No description provided for @totalOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Total outstanding'**
  String get totalOutstanding;

  /// No description provided for @noSuppliersYet.
  ///
  /// In en, this message translates to:
  /// **'No suppliers yet'**
  String get noSuppliersYet;

  /// No description provided for @deleteSupplierTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete supplier'**
  String get deleteSupplierTitle;

  /// No description provided for @confirmDeleteSupplier.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String confirmDeleteSupplier(Object name);

  /// No description provided for @addSupplier.
  ///
  /// In en, this message translates to:
  /// **'Add supplier'**
  String get addSupplier;

  /// No description provided for @supplierDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplier details'**
  String get supplierDetailsTitle;

  /// No description provided for @purchasesTab.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchasesTab;

  /// No description provided for @paymentsTab.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsTab;

  /// No description provided for @outstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding: {value}'**
  String outstanding(Object value);

  /// No description provided for @noPurchasesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No purchases for this month'**
  String get noPurchasesThisMonth;

  /// No description provided for @noPaymentsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No payments for this month'**
  String get noPaymentsThisMonth;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier name'**
  String get supplierName;

  /// No description provided for @itemType.
  ///
  /// In en, this message translates to:
  /// **'Item type'**
  String get itemType;

  /// No description provided for @colorNumber.
  ///
  /// In en, this message translates to:
  /// **'Color number'**
  String get colorNumber;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @totalPurchases.
  ///
  /// In en, this message translates to:
  /// **'Total purchases: {value}'**
  String totalPurchases(Object value);

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid: {value}'**
  String totalPaid(Object value);

  /// No description provided for @clientsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search client'**
  String get clientsSearchHint;

  /// No description provided for @noClientsYet.
  ///
  /// In en, this message translates to:
  /// **'No clients yet'**
  String get noClientsYet;

  /// No description provided for @deleteClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete client'**
  String get deleteClientTitle;

  /// No description provided for @confirmDeleteClient.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String confirmDeleteClient(Object name);

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add client'**
  String get addClient;

  /// No description provided for @clientDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Client details'**
  String get clientDetailsTitle;

  /// No description provided for @modelsTab.
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get modelsTab;

  /// No description provided for @noModelsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No models for this month'**
  String get noModelsThisMonth;

  /// No description provided for @piecesWithPrice.
  ///
  /// In en, this message translates to:
  /// **'{count} pieces • {price}'**
  String piecesWithPrice(Object count, Object price);

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total: {value}'**
  String totalAmount(Object value);

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Client name'**
  String get clientName;

  /// No description provided for @modelName.
  ///
  /// In en, this message translates to:
  /// **'Model name'**
  String get modelName;

  /// No description provided for @pieceCount.
  ///
  /// In en, this message translates to:
  /// **'Piece count'**
  String get pieceCount;

  /// No description provided for @pricePerPiece.
  ///
  /// In en, this message translates to:
  /// **'Price per piece'**
  String get pricePerPiece;

  /// No description provided for @ordersTotal.
  ///
  /// In en, this message translates to:
  /// **'Total orders: {value}'**
  String ordersTotal(Object value);

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid: {value}'**
  String paid(Object value);

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} is ready for implementation.'**
  String featureComingSoon(Object feature);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
