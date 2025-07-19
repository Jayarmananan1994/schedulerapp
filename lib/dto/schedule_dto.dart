import 'package:flutter/material.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/util/app_util.dart';

class ScheduleDto {
  final String id;
  String title;
  DateTime startTime;
  DateTime endTime;
  final Trainee trainee;
  Trainer trainer;
  String meetingnote;
  String? location;
  final bool isCancelled;
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
    this.isCancelled,
    this.package,
  );

  Color getColorByStatus() {
    if (isSameDate(DateTime.now(), startTime)) {
      return Colors.blue.shade200;
    }
    if (startTime.isAfter(DateTime.now())) {
      return Colors.lightGreen.shade300;
    }
    return Colors.white60;
  }

  bool isScheduleUnUsed() {
    return !isCancelled && startTime.isAfter(DateTime.now());
  }

  bool isCompletedSchedule() {
    return !isCancelled && DateTime.now().isAfter(endTime);
  }

  bool intersects(ScheduleDto other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }
}
