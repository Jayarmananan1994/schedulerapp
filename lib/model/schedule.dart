import 'package:hive_flutter/adapters.dart';
import 'package:schedulerapp/model/trainee.dart';
import 'package:schedulerapp/model/staff.dart';

part 'schedule.g.dart';

@HiveType(typeId: 0)
class Schedule {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime startTime;
  @HiveField(3)
  final DateTime endTime;
  @HiveField(4)
  final int color;
  @HiveField(5)
  final Trainee trainee;
  @HiveField(6)
  final Staff trainer;
  @HiveField(7)
  final String meetingnote;
  @HiveField(8)
  final String? location;

  Schedule({
    required this.id,
    this.title = '',
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.trainee,
    required this.trainer,
    this.meetingnote = '',
    this.location = 'ActiveSG',
  });

  bool intersects(Schedule other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }

  @override
  String toString() {
    return 'ScheduleItem(title: $title, startTime: $startTime, endTime: $endTime, client: ${trainee.name}, staff: ${trainer.name}, meetingnote: $meetingnote)';
  }
}
