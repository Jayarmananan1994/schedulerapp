import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';

class StaffPayroll {
  final Trainer trainer;
  final int sessionCompleted;
  final int upcomingSessionCount;
  final DateTime lastPaidDate;
  final int lastMonthSessions;
  final double lastMonthPaid;
  final double dueAmount;
  List<ScheduleDto> upcomingSchedules;

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
