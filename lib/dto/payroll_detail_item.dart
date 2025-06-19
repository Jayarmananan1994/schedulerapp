import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/models/trainer.dart';

class PayrollDetailItem {
  final Trainer trainer;
  final int sessionsCompleted;
  final int noOfUpcomingSessions;
  final double amountEarned;
  final int prevMonthSessionCompleted;
  final double amountEarnedLastMonth;
  final List<Schedule> upcomingSessions;

  PayrollDetailItem({
    required this.trainer,
    required this.sessionsCompleted,
    required this.noOfUpcomingSessions,
    required this.amountEarned,
    required this.prevMonthSessionCompleted,
    required this.amountEarnedLastMonth,
    required this.upcomingSessions,
  });
}
