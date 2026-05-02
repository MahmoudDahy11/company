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
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get notes => 'ملاحظات';

  @override
  String get amount => 'المبلغ';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String phone(Object value) {
    return 'الهاتف: $value';
  }

  @override
  String get noPhoneNumber => 'لا يوجد رقم هاتف';

  @override
  String get failedToLoadData => 'تعذر تحميل البيانات';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String registrationDate(Object value) {
    return 'تاريخ التسجيل: $value';
  }

  @override
  String get dashboardSummaryWorkersWages => 'إجمالي أجور العمال';

  @override
  String get dashboardSummaryWomenWages => 'إجمالي أجور الحريم';

  @override
  String get dashboardSummaryThreadPurchases => 'إجمالي مشتريات الخيوط';

  @override
  String get dashboardSummaryClientOutstanding => 'إجمالي على الزبايين';

  @override
  String get dashboardQuickInfoTitle => 'معلومات سريعة';

  @override
  String get dashboardRegisteredWorkers => 'عدد العمال المسجلين';

  @override
  String get dashboardAbsentDaysThisMonth => 'أيام الغياب هذا الشهر';

  @override
  String get dashboardPendingClients => 'الزباين المتبقين';

  @override
  String get dashboardSuppliersOutstanding => 'موردون لهم رصيد';

  @override
  String get dashboardTopWorkersChart => 'أفضل 5 عمال هذا الشهر';

  @override
  String get dashboardThreadsYearChart => 'مشتريات الخيوط خلال السنة';

  @override
  String get dashboardClientsDistributionChart => 'توزيع ديون الزباين';

  @override
  String get dashboardWomenAdvancesChart => 'سلف الحريم هذا الشهر';

  @override
  String get noCurrentDebts => 'لا توجد ديون حالية';

  @override
  String get workersSearchHint => 'ابحث عن عامل';

  @override
  String get stitchRate => 'سعر الغرزة';

  @override
  String get noWorkersYet => 'لا يوجد عمال حتى الآن';

  @override
  String get deleteWorkerTitle => 'حذف العامل';

  @override
  String confirmDeleteWorker(Object name) {
    return 'هل تريد حذف $name؟';
  }

  @override
  String get addWorker => 'إضافة عامل';

  @override
  String get workerDetailsTitle => 'تفاصيل العامل';

  @override
  String get summaryTab => 'الملخص';

  @override
  String get productionTab => 'الإنتاج';

  @override
  String get advancesTab => 'السلف';

  @override
  String currentRatePer100k(Object value) {
    return 'السعر الحالي لكل 100,000 غرزة: $value';
  }

  @override
  String get totalStitches => 'إجمالي الغرز';

  @override
  String get earnings => 'الأرباح';

  @override
  String get advances => 'السلف';

  @override
  String get carryOver => 'الترحيل';

  @override
  String get absentDays => 'أيام الغياب';

  @override
  String get netSalary => 'الصافي';

  @override
  String get noProductionThisMonth => 'لا توجد سجلات إنتاج لهذا الشهر';

  @override
  String stitchesValue(Object value) {
    return 'الغرز: $value';
  }

  @override
  String earningsValue(Object value) {
    return 'الأرباح: $value';
  }

  @override
  String get noAdvancesThisMonth => 'لا توجد سلف لهذا الشهر';

  @override
  String get addProduction => 'إضافة إنتاج';

  @override
  String get addAdvance => 'إضافة سلفة';

  @override
  String get addPayment => 'إضافة دفعة';

  @override
  String get addPurchase => 'إضافة شراء';

  @override
  String get addModel => 'إضافة موديل';

  @override
  String get workerName => 'اسم العامل';

  @override
  String get updateStitchRate => 'تحديث سعر الغرزة';

  @override
  String get ratePer100kStitches => 'السعر لكل 100,000 غرزة';

  @override
  String get editProduction => 'تعديل الإنتاج';

  @override
  String get stitchCount => 'عدد الغرز';

  @override
  String get daysCount => 'عدد الأيام';

  @override
  String get womenStaffSearchHint => 'ابحث عن موظفة';

  @override
  String get noWomenStaffYet => 'لا توجد موظفات حتى الآن';

  @override
  String get deleteStaffTitle => 'حذف الموظفة';

  @override
  String confirmDeleteStaff(Object name) {
    return 'هل تريد حذف $name؟';
  }

  @override
  String get addStaff => 'إضافة موظفة';

  @override
  String get staffDetailsTitle => 'تفاصيل الموظفة';

  @override
  String get fixedSalary => 'الراتب الثابت';

  @override
  String get updateSalary => 'تعديل الراتب';

  @override
  String get staffName => 'الاسم';

  @override
  String get monthlySalary => 'الراتب الشهري';

  @override
  String get threadsSearchHint => 'ابحث عن مورد';

  @override
  String get monthlyPurchases => 'مشتريات الشهر';

  @override
  String get yearlyPurchases => 'مشتريات السنة';

  @override
  String get yearlyPayments => 'مدفوعات السنة';

  @override
  String get totalOutstanding => 'إجمالي المتبقي';

  @override
  String get noSuppliersYet => 'لا يوجد موردون حتى الآن';

  @override
  String get deleteSupplierTitle => 'حذف المورد';

  @override
  String confirmDeleteSupplier(Object name) {
    return 'هل تريد حذف $name؟';
  }

  @override
  String get addSupplier => 'إضافة مورد';

  @override
  String get supplierDetailsTitle => 'تفاصيل المورد';

  @override
  String get purchasesTab => 'المشتريات';

  @override
  String get paymentsTab => 'المدفوعات';

  @override
  String outstanding(Object value) {
    return 'المتبقي: $value';
  }

  @override
  String get noPurchasesThisMonth => 'لا توجد مشتريات لهذا الشهر';

  @override
  String get noPaymentsThisMonth => 'لا توجد مدفوعات لهذا الشهر';

  @override
  String get supplierName => 'اسم المورد';

  @override
  String get itemType => 'نوع الصنف';

  @override
  String get colorNumber => 'رقم اللون';

  @override
  String get price => 'السعر';

  @override
  String get quantity => 'الكمية';

  @override
  String get unit => 'الوحدة';

  @override
  String totalPurchases(Object value) {
    return 'إجمالي المشتريات: $value';
  }

  @override
  String totalPaid(Object value) {
    return 'إجمالي المدفوع: $value';
  }

  @override
  String get clientsSearchHint => 'ابحث عن زبون';

  @override
  String get noClientsYet => 'لا يوجد زباين حتى الآن';

  @override
  String get deleteClientTitle => 'حذف الزبون';

  @override
  String confirmDeleteClient(Object name) {
    return 'هل تريد حذف $name؟';
  }

  @override
  String get addClient => 'إضافة زبون';

  @override
  String get clientDetailsTitle => 'تفاصيل الزبون';

  @override
  String get modelsTab => 'الموديلات';

  @override
  String get noModelsThisMonth => 'لا توجد موديلات لهذا الشهر';

  @override
  String piecesWithPrice(Object count, Object price) {
    return '$count قطعة • $price';
  }

  @override
  String totalAmount(Object value) {
    return 'الإجمالي: $value';
  }

  @override
  String get clientName => 'اسم الزبون';

  @override
  String get modelName => 'اسم الموديل';

  @override
  String get pieceCount => 'عدد القطع';

  @override
  String get pricePerPiece => 'السعر للقطعة';

  @override
  String ordersTotal(Object value) {
    return 'إجمالي الطلبات: $value';
  }

  @override
  String paid(Object value) {
    return 'المدفوع: $value';
  }

  @override
  String featureComingSoon(Object feature) {
    return '$feature جاهز للتنفيذ.';
  }
}
