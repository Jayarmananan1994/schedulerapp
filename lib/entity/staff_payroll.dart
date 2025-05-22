import 'package:schedulerapp/entity/schedule.dart';
import 'package:schedulerapp/entity/staff.dart';

class StaffPayroll {
  final Staff staff;
  final int sessionCompleted;
  final int upcomingSessionCount;
  final DateTime lastPaidDate;
  final int lastMonthSessions;
  final int lastMonthPaid;
  final double dueAmount;
  List<Schedule> upcomingSchedules = [];

  StaffPayroll({
    required this.staff,
    required this.sessionCompleted,
    required this.upcomingSessionCount,
    required this.lastPaidDate,
    required this.lastMonthSessions,
    required this.lastMonthPaid,
    required this.dueAmount,
  });
}
