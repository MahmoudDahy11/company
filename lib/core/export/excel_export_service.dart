import 'dart:io';

import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/clients/domain/entities/client_list_item.dart';
import '../../features/threads/domain/entities/supplier_list_item.dart';
import '../../features/threads/domain/entities/thread_purchase.dart';
import '../../features/workers/domain/entities/worker_list_item.dart';
import '../../features/women_staff/domain/entities/staff_list_item.dart';

/// Centralized Excel export service for all features.
@lazySingleton
class ExcelExportService {
  static final _headerStyle = CellStyle(
    bold: true,
    fontColorHex: ExcelColor.white,
    backgroundColorHex: ExcelColor.fromHexString('#0F766E'),
    horizontalAlign: HorizontalAlign.Center,
  );

  static final _workerRowStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString('#E0F2F1'),
  );

  static final _staffRowStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString('#FCE4EC'),
  );

  // ───────── Workers + Women Staff (combined sheet) ─────────

  Future<void> exportPayroll({
    required List<WorkerListItem> workers,
    required List<StaffListItem> staff,
    required DateTime month,
    required bool isArabic,
  }) async {
    final excel = Excel.createExcel();
    final monthLabel = DateFormat('yyyy-MM').format(month);
    final sheetName = monthLabel;
    final sheet = excel[sheetName];
    excel.delete('Sheet1');

    // Headers
    final headers = isArabic
        ? [
            'الاسم',
            'النوع',
            'إجمالي الغرز / الراتب',
            'السلف',
            'الترحيل',
            'الصافي',
          ]
        : [
            'Name',
            'Type',
            'Earnings / Salary',
            'Advances',
            'Carry-over',
            'Net Salary',
          ];

    for (var col = 0; col < headers.length; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = _headerStyle;
    }

    var row = 1;

    // Worker rows
    for (final worker in workers) {
      final values = <CellValue>[
        TextCellValue(worker.name),
        TextCellValue(isArabic ? 'عامل' : 'Worker'),
        DoubleCellValue(worker.totalEarnings),
        DoubleCellValue(worker.totalAdvances),
        DoubleCellValue(0), // carry-over not available in list item
        DoubleCellValue(worker.netSalary),
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
        );
        cell.value = values[col];
        cell.cellStyle = _workerRowStyle;
      }
      row++;
    }

    // Staff rows (pink)
    for (final member in staff) {
      final values = <CellValue>[
        TextCellValue(member.name),
        TextCellValue(isArabic ? 'موظفة' : 'Staff'),
        DoubleCellValue(member.monthlySalary),
        DoubleCellValue(member.totalAdvances),
        DoubleCellValue(0),
        DoubleCellValue(member.netSalary),
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
        );
        cell.value = values[col];
        cell.cellStyle = _staffRowStyle;
      }
      row++;
    }

    // Auto-fit columns
    for (var col = 0; col < headers.length; col++) {
      sheet.setColumnWidth(col, 22);
    }

    await _saveAndOpen(excel, 'payroll_$monthLabel.xlsx');
  }

  // ───────── Threads / Suppliers ─────────

  Future<void> exportThreads({
    required List<SupplierListItem> suppliers,
    required List<ThreadPurchase> allPurchases,
    required DateTime month,
    required bool isArabic,
  }) async {
    final excel = Excel.createExcel();
    final monthLabel = DateFormat('yyyy-MM').format(month);
    excel.delete('Sheet1');

    // Monthly detail sheet
    final detailSheet = excel[monthLabel];
    final detailHeaders = isArabic
        ? [
            'الصنف',
            'رقم اللون',
            'المورد',
            'التاريخ',
            'السعر',
            'الكمية',
            'الوحدة',
          ]
        : [
            'Item',
            'Color No.',
            'Supplier',
            'Date',
            'Price',
            'Quantity',
            'Unit',
          ];

    for (var col = 0; col < detailHeaders.length; col++) {
      final cell = detailSheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );
      cell.value = TextCellValue(detailHeaders[col]);
      cell.cellStyle = _headerStyle;
    }

    // Build a supplier name map
    final supplierNameMap = <int, String>{};
    for (final s in suppliers) {
      supplierNameMap[s.id] = s.name;
    }

    var row = 1;
    for (final purchase in allPurchases) {
      final values = <CellValue>[
        TextCellValue(purchase.itemName),
        TextCellValue(purchase.colorNumber),
        TextCellValue(supplierNameMap[purchase.supplierId] ?? ''),
        TextCellValue(DateFormat('yyyy-MM-dd').format(purchase.purchaseDate)),
        DoubleCellValue(purchase.price),
        DoubleCellValue(purchase.quantity),
        TextCellValue(purchase.unit),
      ];
      for (var col = 0; col < values.length; col++) {
        detailSheet
                .cell(
                  CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
                )
                .value =
            values[col];
      }
      row++;
    }

    for (var col = 0; col < detailHeaders.length; col++) {
      detailSheet.setColumnWidth(col, 18);
    }

    // Annual summary sheet
    final summaryName = isArabic ? 'ملخص سنوي' : 'Annual Summary';
    final summarySheet = excel[summaryName];
    final summaryHeaders = isArabic
        ? ['المورد', 'إجمالي المشتريات', 'إجمالي المدفوع', 'المتبقي']
        : ['Supplier', 'Total Purchased', 'Total Paid', 'Outstanding'];

    for (var col = 0; col < summaryHeaders.length; col++) {
      final cell = summarySheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );
      cell.value = TextCellValue(summaryHeaders[col]);
      cell.cellStyle = _headerStyle;
    }

    row = 1;
    for (final supplier in suppliers) {
      final values = <CellValue>[
        TextCellValue(supplier.name),
        DoubleCellValue(supplier.totalPurchased),
        DoubleCellValue(supplier.totalPaid),
        DoubleCellValue(supplier.outstandingBalance),
      ];
      for (var col = 0; col < values.length; col++) {
        summarySheet
                .cell(
                  CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
                )
                .value =
            values[col];
      }
      row++;
    }

    for (var col = 0; col < summaryHeaders.length; col++) {
      summarySheet.setColumnWidth(col, 22);
    }

    await _saveAndOpen(excel, 'threads_$monthLabel.xlsx');
  }

  // ───────── Clients ─────────

  Future<void> exportClients({
    required List<ClientListItem> clients,
    required DateTime month,
    required bool isArabic,
  }) async {
    final excel = Excel.createExcel();
    final monthLabel = DateFormat('yyyy-MM').format(month);
    excel.delete('Sheet1');

    final sheet = excel[monthLabel];
    final headers = isArabic
        ? ['الزبون', 'إجمالي الطلبات', 'المدفوع', 'المتبقي']
        : ['Client', 'Total Orders', 'Paid', 'Outstanding'];

    for (var col = 0; col < headers.length; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = _headerStyle;
    }

    var row = 1;
    for (final client in clients) {
      final values = <CellValue>[
        TextCellValue(client.name),
        DoubleCellValue(client.totalAmount),
        DoubleCellValue(client.totalPaid),
        DoubleCellValue(client.outstanding),
      ];
      for (var col = 0; col < values.length; col++) {
        sheet
                .cell(
                  CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
                )
                .value =
            values[col];
      }
      row++;
    }

    for (var col = 0; col < headers.length; col++) {
      sheet.setColumnWidth(col, 22);
    }

    await _saveAndOpen(excel, 'clients_$monthLabel.xlsx');
  }

  // ───────── Helpers ─────────

  Future<void> _saveAndOpen(Excel excel, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(dir.path, 'factory_exports'));
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }
    final filePath = p.join(exportDir.path, fileName);
    final bytes = excel.encode();
    if (bytes == null) return;
    File(filePath).writeAsBytesSync(bytes);
    await OpenFile.open(filePath);
  }
}
