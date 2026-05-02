import 'staff_advance.dart';
import 'staff_member.dart';
import 'staff_month_summary.dart';

class StaffDetailsData {
  const StaffDetailsData({
    required this.staffMember,
    required this.summary,
    required this.advances,
  });

  final StaffMember staffMember;
  final StaffMonthSummary summary;
  final List<StaffAdvance> advances;
}
