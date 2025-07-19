import 'package:schedulerapp/data/models/trainee.dart';

class ScheduleHistoryDto {
  final String id;
  final Trainee trainee;
  final String trainerId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isCancelled;
  final bool isCompleted;

  ScheduleHistoryDto({
    required this.id,
    required this.trainee,
    required this.trainerId,
    required this.startTime,
    required this.endTime,
    required this.isCancelled,
    required this.isCompleted,
  });
}
