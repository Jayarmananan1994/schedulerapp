import 'package:flutter/material.dart';
import 'package:schedulerapp/model/user.dart';

class ScheduleItem {
  final int id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final List<User> participants;
  final String meetingnote;

  ScheduleItem({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.participants,
    this.meetingnote = '',
  });

  bool intersects(ScheduleItem other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }
}
