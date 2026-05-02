import 'supplier.dart';
import 'supplier_payment.dart';
import 'supplier_summary.dart';
import 'thread_purchase.dart';

class SupplierDetailsData {
  const SupplierDetailsData({
    required this.supplier,
    required this.summary,
    required this.purchases,
    required this.payments,
  });

  final Supplier supplier;
  final SupplierSummary summary;
  final List<ThreadPurchase> purchases;
  final List<SupplierPaymentEntry> payments;
}
