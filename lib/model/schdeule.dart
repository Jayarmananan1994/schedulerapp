import 'package:flutter/material.dart';
import 'package:schedulerapp/model/user.dart';

class Schedule {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final List<User> participants;
  final String meetingnote;

  Schedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.participants,
    required this.meetingnote,
  });

  bool overlapsWith(Schedule other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }
}
