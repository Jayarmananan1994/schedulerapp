import 'package:hive_flutter/adapters.dart';

part 'schedule.g.dart';

@HiveType(typeId: 0)
class Schedule extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime startTime;
  @HiveField(3)
  DateTime endTime;
  @HiveField(4)
  final String traineeId;
  @HiveField(5)
  String trainerId;
  @HiveField(6)
  String meetingnote;
  @HiveField(7)
  String? location;
  @HiveField(8)
  final double traineeFee;
  @HiveField(9)
  final double trainerCost;
  @HiveField(10)
  bool isCancelled = false;
  @HiveField(11)
  bool isForfeited = false;
  @HiveField(12)
  String packageId;

  Schedule({
    required this.id,
    this.title = '',
    required this.startTime,
    required this.endTime,
    required this.traineeId,
    required this.trainerId,
    this.meetingnote = '',
    this.location = 'ActiveSG',
    required this.traineeFee,
    required this.trainerCost,
    required this.packageId,
  });

  bool intersects(Schedule other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }

  @override
  String toString() {
    return 'ScheduleItem(title: $title, startTime: $startTime, endTime: $endTime, trainee: $traineeId, trainer: $trainerId, meetingnote: $meetingnote)';
  }

  bool isScheduleUnUsed() {
    return startTime.isAfter(DateTime.now());
  }

  bool isLapsedSchedule() {
    return DateTime.now().isAfter(endTime) && !isCancelled;
  }

  bool isCompletedSchedule() {
    return !isCancelled && DateTime.now().isAfter(endTime);
  }
}
