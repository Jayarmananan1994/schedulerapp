import 'package:flutter/material.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/util/app_util.dart';

class ScheduleDto {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Trainee trainee;
  final Trainer trainer;
  final String meetingnote;
  final String? location;
  final GymPackage package;

  ScheduleDto(
    this.id,
    this.title,
    this.startTime,
    this.endTime,
    this.trainee,
    this.trainer,
    this.meetingnote,
    this.location,
    this.package,
  );

  Color getColorByStatus() {
    // if (isCancelled) {
    //   return Colors.red.shade200;
    // }
    // if (isForfeited) {
    //   return Colors.amber.shade300;
    // }
    if (isSameDate(DateTime.now(), startTime)) {
      return Colors.blue.shade200;
    }
    if (startTime.isAfter(DateTime.now())) {
      return Colors.lightGreen.shade300;
    }
    return Colors.white60;
  }

  // bool isLapsedSchedule() {
  //   return DateTime.now().isAfter(endTime) && !isCancelled;
  // }

  bool isScheduleUnUsed() {
    return startTime.isAfter(DateTime.now());
  }

  bool isCompletedSchedule() {
    return DateTime.now().isAfter(endTime);
  }

  bool intersects(ScheduleDto other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }
}
