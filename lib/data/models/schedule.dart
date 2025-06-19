import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/util/app_util.dart';
part 'schedule.g.dart';

@HiveType(typeId: 0)
class Schedule extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime startTime;
  @HiveField(3)
  final DateTime endTime;
  @HiveField(4)
  final Trainee trainee;
  @HiveField(5)
  final Trainer trainer;
  @HiveField(6)
  final String meetingnote;
  @HiveField(7)
  final String? location;
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
    required this.trainee,
    required this.trainer,
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
    return 'ScheduleItem(title: $title, startTime: $startTime, endTime: $endTime, client: ${trainee.name}, trainer: ${trainer.name}, meetingnote: $meetingnote)';
  }

  bool isLapsedSchedule() {
    return DateTime.now().isAfter(endTime) && !isCancelled;
  }

  bool isScheduleUnUsed() {
    return startTime.isAfter(DateTime.now());
  }

  Color getColorByStatus() {
    if (isCancelled) {
      return Colors.red.shade200;
    }
    if (isForfeited) {
      return Colors.amber.shade300;
    }
    if (isSameDate(DateTime.now(), startTime)) {
      return Colors.blue.shade200;
    }
    if (startTime.isAfter(DateTime.now())) {
      return Colors.lightGreen.shade300;
    }
    return Colors.white60;
  }

  Schedule copyWith({
    required DateTime startTime,
    required Trainer trainer,
    required Trainee trainee,
  }) {
    return Schedule(
      id: id,
      title: title,
      startTime: startTime,
      endTime: endTime,
      trainee: trainee,
      trainer: trainer,
      meetingnote: meetingnote,
      location: location,
      traineeFee: trainee.feePerSession,
      trainerCost: trainer.payRate,
      packageId: '',
    );
  }
}
