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
  String get date => 'التاريخ';

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
  String get clearSyncQueue => 'مسح قائمة الانتظار';

  @override
  String get confirmClearSyncQueue =>
      'هل تريد مسح كافة العمليات المعلقة؟ هذا الإجراء قد يمنع رفع التعديلات الحالية للخادم.';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get loginTitle => 'دخول المدير';

  @override
  String get loginSubtitle => 'سجّل الدخول بحساب المدير لفتح نظام المصنع.';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get signOut => 'تسجيل الخروج';

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
  String get dashboardSummaryWorkersWages => 'أجور العمال';

  @override
  String get dashboardSummaryWomenWages => 'أجور الحريم';

  @override
  String get dashboardSummaryThreadPurchases => 'مشتريات الخيط';

  @override
  String get dashboardSummaryClientOutstanding => 'ديون الزبائن';

  @override
  String get dashboardSummaryMaintenanceCost => 'مصروفات الصيانة';

  @override
  String workersAndAbsence(Object workers, Object absence) {
    return '$workers عمال، $absence أيام غياب';
  }

  @override
  String suppliersOutstanding(Object count) {
    return '$count موردين لهم مستحقات';
  }

  @override
  String clientsDebts(Object count) {
    return '$count زبائن عليهم ديون';
  }

  @override
  String get dashboardTopWorkersChart => 'إنتاج العمال (أعلى 10)';

  @override
  String dashboardThreadsYearChart(Object year) {
    return 'مشتريات الخيط ($year)';
  }

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
  String get addAdvance => 'اضافه سلفه';

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

  @override
  String get exportExcel => 'تصدير إكسيل';

  @override
  String get exportPayroll => 'تصدير كشف المرتبات';

  @override
  String get exportThreads => 'تصدير الخيوط';

  @override
  String get exportClients => 'تصدير الزباين';

  @override
  String get exportSuccess => 'تم تصدير الملف بنجاح';

  @override
  String get exportError => 'فشل تصدير الملف';

  @override
  String get workersList => 'قائمة العمال';

  @override
  String get womenStaffList => 'قائمة الحريم';

  @override
  String get suppliersList => 'قائمة الموردين';

  @override
  String get clientsList => 'قائمة الزباين';

  @override
  String get name => 'الاسم';

  @override
  String get netSalaryHeader => 'صافي الراتب';

  @override
  String get advancesHeader => 'السلف';

  @override
  String get absentDaysHeader => 'أيام الغياب';

  @override
  String get actions => 'الإجراءات';

  @override
  String get details => 'تفاصيل';

  @override
  String get basicSalary => 'الراتب الأساسي';

  @override
  String get totalPurchasesHeader => 'إجمالي المشتريات';

  @override
  String get totalPaidHeader => 'إجمالي المدفوع';

  @override
  String get remainingBalance => 'الرصيد المتبقي';

  @override
  String get totalAmountHeader => 'إجمالي المبلغ';

  @override
  String get deleteModelTitle => 'حذف الموديل';

  @override
  String confirmDeleteModel(Object name) {
    return 'هل تريد حذف موديل $name؟';
  }

  @override
  String get deletePaymentTitle => 'حذف الدفعة';

  @override
  String confirmDeletePayment(Object amount) {
    return 'هل تريد حذف هذه الدفعة بقيمة $amount؟';
  }

  @override
  String get financialOverview => 'المركز المالي';

  @override
  String get totalDueFromClients => 'إجمالي عندنا (الزبايين)';

  @override
  String get totalDueToSuppliers => 'إجمالي علينا (الخيوط)';

  @override
  String get totalMaintenanceCost => 'إجمالي مصاريف الصيانة';

  @override
  String get clientsAnnualTable => 'جدول الزبايين';

  @override
  String get threadsAnnualTable => 'جدول الخيوط';

  @override
  String get totalWork => 'إجمالي الشغل';

  @override
  String get remaining => 'المتبقي';

  @override
  String get remainingOur => 'المتبقي علينا';

  @override
  String get last3Months => 'آخر 3 شهور';

  @override
  String get last6Months => 'آخر 6 شهور';

  @override
  String get lastYear => 'آخر سنة';

  @override
  String get deleteProductionTitle => 'حذف الإنتاج';

  @override
  String get confirmDeleteProduction => 'هل تريد حذف سجل الإنتاج هذا؟';

  @override
  String get deleteAdvanceTitle => 'حذف السلفة';

  @override
  String get confirmDeleteAdvance => 'هل تريد حذف سجل السلفة هذا؟';

  @override
  String get editAdvance => 'تعديل سلفة';

  @override
  String get editModel => 'تعديل موديل';

  @override
  String get editPurchase => 'تعديل شراء';

  @override
  String get editPayment => 'تعديل دفعة';

  @override
  String get deletePurchaseTitle => 'حذف الشراء';

  @override
  String get confirmDeletePurchase => 'هل تريد حذف سجل الشراء هذا؟';

  @override
  String get priceMustBePositive => 'يجب أن يكون السعر أكبر من 0';

  @override
  String get quantityMustBePositive => 'يجب أن تكون الكمية أكبر من 0';

  @override
  String get amountMustBePositive => 'يجب أن يكون المبلغ أكبر من 0';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get passwordTooWeak => 'يجب أن تحتوي كلمة المرور على حرف كبير ورقم';

  @override
  String get invalidPhone => 'يرجى إدخال رقم هاتف صالح';

  @override
  String get invalidNumber => 'يرجى إدخال رقم صالح';

  @override
  String valueTooSmall(Object min) {
    return 'القيمة يجب أن تكون على الأقل $min';
  }

  @override
  String valueTooLarge(Object max) {
    return 'القيمة يجب ألا تزيد عن $max';
  }

  @override
  String get deductions => 'الخصومات';

  @override
  String get addDeduction => 'خصم';

  @override
  String get noDeductionsThisMonth => 'لا توجد خصومات لهذا الشهر';

  @override
  String get deleteDeductionTitle => 'حذف الخصم';

  @override
  String get confirmDeleteDeduction => 'هل تريد حذف سجل الخصم هذا؟';

  @override
  String get faultRecords => 'سجلات الأعطال';

  @override
  String get maintenanceFaults => 'الصيانة';

  @override
  String get addFaultRecord => 'إضافة سجل عطل';

  @override
  String get editFaultRecord => 'تعديل سجل العطل';

  @override
  String get noFaultRecordsYet => 'لا توجد سجلات أعطال حتى الآن';

  @override
  String get deleteFaultRecordTitle => 'حذف السجل';

  @override
  String confirmDeleteFaultRecord(Object machine) {
    return 'هل تريد حذف سجل عطل $machine؟';
  }

  @override
  String get machineName => 'اسم الآلة';

  @override
  String get faultName => 'اسم العطل';

  @override
  String get cost => 'التكلفة';

  @override
  String get totalCost => 'التكلفة الإجمالية';
}
