import 'package:schedulerapp/entity/schedule.dart';
import 'package:schedulerapp/entity/staff.dart';

class PayrollDetailItem {
  final Staff staff;
  final int sessionsCompleted;
  final int noOfUpcomingSessions;
  final double amountEarned;
  final int prevMonthSessionCompleted;
  final double amountEarnedLastMonth;
  final List<Schedule> upcomingSessions;

  PayrollDetailItem({
    required this.staff,
    required this.sessionsCompleted,
    required this.noOfUpcomingSessions,
    required this.amountEarned,
    required this.prevMonthSessionCompleted,
    required this.amountEarnedLastMonth,
    required this.upcomingSessions,
  });
}
