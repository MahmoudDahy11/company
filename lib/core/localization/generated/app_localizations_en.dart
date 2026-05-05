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
  String get date => 'Date';

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
  String get clearSyncQueue => 'Clear Sync Queue';

  @override
  String get confirmClearSyncQueue =>
      'Do you want to clear all pending operations? This may prevent current changes from being uploaded to the server.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get requiredField => 'This field is required';

  @override
  String get loginTitle => 'Admin login';

  @override
  String get loginSubtitle =>
      'Sign in with the admin account to open the factory system.';

  @override
  String get loginButton => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get notes => 'Notes';

  @override
  String get amount => 'Amount';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String phone(Object value) {
    return 'Phone: $value';
  }

  @override
  String get noPhoneNumber => 'No phone number';

  @override
  String get failedToLoadData => 'Failed to load data';

  @override
  String get noData => 'No data';

  @override
  String registrationDate(Object value) {
    return 'Registration date: $value';
  }

  @override
  String get dashboardSummaryWorkersWages => 'Worker wages';

  @override
  String get dashboardSummaryWomenWages => 'Women staff wages';

  @override
  String get dashboardSummaryThreadPurchases => 'Thread purchases';

  @override
  String get dashboardSummaryClientOutstanding => 'Client debts';

  @override
  String workersAndAbsence(Object workers, Object absence) {
    return '$workers workers, $absence absent days';
  }

  @override
  String suppliersOutstanding(Object count) {
    return '$count suppliers with outstanding';
  }

  @override
  String clientsDebts(Object count) {
    return '$count clients with debts';
  }

  @override
  String get dashboardTopWorkersChart => 'Worker production (Top 10)';

  @override
  String dashboardThreadsYearChart(Object year) {
    return 'Thread purchases ($year)';
  }

  @override
  String get dashboardClientsDistributionChart => 'Client balance distribution';

  @override
  String get dashboardWomenAdvancesChart => 'Women staff advances this month';

  @override
  String get noCurrentDebts => 'There are no current debts';

  @override
  String get workersSearchHint => 'Search worker';

  @override
  String get stitchRate => 'Stitch rate';

  @override
  String get noWorkersYet => 'No workers yet';

  @override
  String get deleteWorkerTitle => 'Delete worker';

  @override
  String confirmDeleteWorker(Object name) {
    return 'Delete $name?';
  }

  @override
  String get addWorker => 'Add worker';

  @override
  String get workerDetailsTitle => 'Worker details';

  @override
  String get summaryTab => 'Summary';

  @override
  String get productionTab => 'Production';

  @override
  String get advancesTab => 'Advances';

  @override
  String currentRatePer100k(Object value) {
    return 'Current rate per 100,000 stitches: $value';
  }

  @override
  String get totalStitches => 'Total stitches';

  @override
  String get earnings => 'Earnings';

  @override
  String get advances => 'Advances';

  @override
  String get carryOver => 'Carry-over';

  @override
  String get absentDays => 'Absent days';

  @override
  String get netSalary => 'Net salary';

  @override
  String get noProductionThisMonth => 'No production records for this month';

  @override
  String stitchesValue(Object value) {
    return 'Stitches: $value';
  }

  @override
  String earningsValue(Object value) {
    return 'Earnings: $value';
  }

  @override
  String get noAdvancesThisMonth => 'No advances for this month';

  @override
  String get addProduction => 'Add production';

  @override
  String get addAdvance => 'Add advance';

  @override
  String get addPayment => 'Add payment';

  @override
  String get addPurchase => 'Add purchase';

  @override
  String get addModel => 'Add model';

  @override
  String get workerName => 'Worker name';

  @override
  String get updateStitchRate => 'Update stitch rate';

  @override
  String get ratePer100kStitches => 'Rate per 100,000 stitches';

  @override
  String get editProduction => 'Edit production';

  @override
  String get stitchCount => 'Stitch count';

  @override
  String get daysCount => 'Number of days';

  @override
  String get womenStaffSearchHint => 'Search staff member';

  @override
  String get noWomenStaffYet => 'No women staff yet';

  @override
  String get deleteStaffTitle => 'Delete staff member';

  @override
  String confirmDeleteStaff(Object name) {
    return 'Delete $name?';
  }

  @override
  String get addStaff => 'Add staff member';

  @override
  String get staffDetailsTitle => 'Staff details';

  @override
  String get fixedSalary => 'Fixed salary';

  @override
  String get updateSalary => 'Update salary';

  @override
  String get staffName => 'Name';

  @override
  String get monthlySalary => 'Monthly salary';

  @override
  String get threadsSearchHint => 'Search supplier';

  @override
  String get monthlyPurchases => 'Monthly purchases';

  @override
  String get yearlyPurchases => 'Yearly purchases';

  @override
  String get yearlyPayments => 'Yearly payments';

  @override
  String get totalOutstanding => 'Total outstanding';

  @override
  String get noSuppliersYet => 'No suppliers yet';

  @override
  String get deleteSupplierTitle => 'Delete supplier';

  @override
  String confirmDeleteSupplier(Object name) {
    return 'Delete $name?';
  }

  @override
  String get addSupplier => 'Add supplier';

  @override
  String get supplierDetailsTitle => 'Supplier details';

  @override
  String get purchasesTab => 'Purchases';

  @override
  String get paymentsTab => 'Payments';

  @override
  String outstanding(Object value) {
    return 'Outstanding: $value';
  }

  @override
  String get noPurchasesThisMonth => 'No purchases for this month';

  @override
  String get noPaymentsThisMonth => 'No payments for this month';

  @override
  String get supplierName => 'Supplier name';

  @override
  String get itemType => 'Item type';

  @override
  String get colorNumber => 'Color number';

  @override
  String get price => 'Price';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'Unit';

  @override
  String totalPurchases(Object value) {
    return 'Total purchases: $value';
  }

  @override
  String totalPaid(Object value) {
    return 'Total paid: $value';
  }

  @override
  String get clientsSearchHint => 'Search client';

  @override
  String get noClientsYet => 'No clients yet';

  @override
  String get deleteClientTitle => 'Delete client';

  @override
  String confirmDeleteClient(Object name) {
    return 'Delete $name?';
  }

  @override
  String get addClient => 'Add client';

  @override
  String get clientDetailsTitle => 'Client details';

  @override
  String get modelsTab => 'Models';

  @override
  String get noModelsThisMonth => 'No models for this month';

  @override
  String piecesWithPrice(Object count, Object price) {
    return '$count pieces • $price';
  }

  @override
  String totalAmount(Object value) {
    return 'Total: $value';
  }

  @override
  String get clientName => 'Client name';

  @override
  String get modelName => 'Model name';

  @override
  String get pieceCount => 'Piece count';

  @override
  String get pricePerPiece => 'Price per piece';

  @override
  String ordersTotal(Object value) {
    return 'Total orders: $value';
  }

  @override
  String paid(Object value) {
    return 'Paid: $value';
  }

  @override
  String featureComingSoon(Object feature) {
    return '$feature is ready for implementation.';
  }

  @override
  String get exportExcel => 'Export Excel';

  @override
  String get exportPayroll => 'Export payroll';

  @override
  String get exportThreads => 'Export threads';

  @override
  String get exportClients => 'Export clients';

  @override
  String get exportSuccess => 'File exported successfully';

  @override
  String get exportError => 'Failed to export file';

  @override
  String get workersList => 'Workers List';

  @override
  String get womenStaffList => 'Women Staff List';

  @override
  String get suppliersList => 'Suppliers List';

  @override
  String get clientsList => 'Clients List';

  @override
  String get name => 'Name';

  @override
  String get netSalaryHeader => 'Net Salary';

  @override
  String get advancesHeader => 'Advances';

  @override
  String get absentDaysHeader => 'Absent Days';

  @override
  String get actions => 'Actions';

  @override
  String get details => 'Details';

  @override
  String get basicSalary => 'Basic Salary';

  @override
  String get totalPurchasesHeader => 'Total Purchases';

  @override
  String get totalPaidHeader => 'Total Paid';

  @override
  String get remainingBalance => 'Remaining Balance';

  @override
  String get totalAmountHeader => 'Total Amount';

  @override
  String get deleteModelTitle => 'Delete Model';

  @override
  String confirmDeleteModel(Object name) {
    return 'Do you want to delete model $name?';
  }

  @override
  String get deletePaymentTitle => 'Delete Payment';

  @override
  String confirmDeletePayment(Object amount) {
    return 'Do you want to delete this payment of $amount?';
  }

  @override
  String get financialOverview => 'Financial Overview';

  @override
  String get totalDueFromClients => 'Total Due From Clients';

  @override
  String get totalDueToSuppliers => 'Total Due To Suppliers';

  @override
  String get clientsAnnualTable => 'Clients Summary';

  @override
  String get threadsAnnualTable => 'Threads Summary';

  @override
  String get totalWork => 'Total Work';

  @override
  String get remaining => 'Remaining';

  @override
  String get remainingOur => 'Remaining (To us)';

  @override
  String get last3Months => 'Last 3 Months';

  @override
  String get last6Months => 'Last 6 Months';

  @override
  String get lastYear => 'Last Year';

  @override
  String get deleteProductionTitle => 'Delete Production';

  @override
  String get confirmDeleteProduction =>
      'Do you want to delete this production record?';

  @override
  String get deleteAdvanceTitle => 'Delete Advance';

  @override
  String get confirmDeleteAdvance =>
      'Do you want to delete this advance record?';

  @override
  String get editAdvance => 'Edit Advance';

  @override
  String get editModel => 'Edit Model';

  @override
  String get editPurchase => 'Edit Purchase';

  @override
  String get editPayment => 'Edit Payment';

  @override
  String get deletePurchaseTitle => 'Delete Purchase';

  @override
  String get confirmDeletePurchase =>
      'Do you want to delete this purchase record?';
}
