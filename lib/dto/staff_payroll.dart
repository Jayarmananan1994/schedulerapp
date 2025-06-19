import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/models/trainer.dart';

class StaffPayroll {
  final Trainer trainer;
  final int sessionCompleted;
  final int upcomingSessionCount;
  final DateTime lastPaidDate;
  final int lastMonthSessions;
  final double lastMonthPaid;
  final double dueAmount;
  List<Schedule> upcomingSchedules;

  StaffPayroll({
    required this.trainer,
    required this.sessionCompleted,
    required this.upcomingSessionCount,
    required this.lastPaidDate,
    required this.lastMonthSessions,
    required this.lastMonthPaid,
    required this.dueAmount,
    this.upcomingSchedules = const [],
  });
}
