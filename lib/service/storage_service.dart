import 'package:flutter/material.dart';
import 'package:schedulerapp/model/schdeule.dart';

class StorageService {
  final Map<DateTime, List<ScheduleItem>> _storage = {
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day - 1,
    ): [
      ScheduleItem(
        id: 1,
        title: 'Client Meeting',
        startTime: DateTime.now().copyWith(hour: 9, minute: 0),
        endTime: DateTime.now().copyWith(hour: 11, minute: 0),
        color: Colors.green.shade200,
        participants: List.empty(growable: true),
      ),
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
      ScheduleItem(
        id: 1,
        title: 'Client Meeting',
        startTime: DateTime.now().copyWith(hour: 9, minute: 0),
        endTime: DateTime.now().copyWith(hour: 11, minute: 0),
        color: Colors.green.shade200,
        participants: List.empty(growable: true),
      ),
      ScheduleItem(
        id: 2,
        title: 'Client Meeting 2',
        startTime: DateTime.now().copyWith(hour: 9, minute: 0),
        endTime: DateTime.now().copyWith(hour: 10, minute: 0),
        color: Colors.red.shade300,
        participants: List.empty(growable: true),
      ),
      ScheduleItem(
        id: 3,
        title: 'Client Meeting 3',
        startTime: DateTime.now().copyWith(hour: 9, minute: 0),
        endTime: DateTime.now().copyWith(hour: 10, minute: 0),
        color: Colors.blue.shade400,
        participants: List.empty(growable: true),
      ),
      ScheduleItem(
        id: 4,
        title: 'Client Meeting 3',
        startTime: DateTime.now().copyWith(hour: 10, minute: 0),
        endTime: DateTime.now().copyWith(hour: 12, minute: 0),
        color: Colors.blue.shade400,
        participants: List.empty(growable: true),
      ),
      ScheduleItem(
        id: 5,
        title: 'Lunch Break',
        startTime: DateTime.now().copyWith(hour: 12, minute: 0),
        endTime: DateTime.now().copyWith(hour: 13, minute: 0),
        color: Colors.orange.shade200,
        participants: List.empty(growable: true),
      ),
      ScheduleItem(
        id: 6,
        title: 'Project Review',
        startTime: DateTime.now().copyWith(hour: 14, minute: 0),
        endTime: DateTime.now().copyWith(hour: 17, minute: 00),
        color: Colors.purple.shade200,
        participants: List.empty(growable: true),
      ),
      ScheduleItem(
        id: 7,
        title: 'Team Sync',
        startTime: DateTime.now().copyWith(hour: 16, minute: 0),
        endTime: DateTime.now().copyWith(hour: 16, minute: 45),
        color: Colors.red.shade200,
        participants: List.empty(growable: true),
      ),
    ],
  };

  List<ScheduleItem> getScheduleItems(DateTime date) {
    return _storage[date] ?? [];
  }

  void addScheduleItem(DateTime date, ScheduleItem item) {
    if (_storage[date] == null) {
      _storage[date] = [];
    }
    _storage[date]!.add(item);
  }
}
