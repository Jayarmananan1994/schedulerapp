import 'package:hive/hive.dart';
import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/data/repositories/schedule_repository.dart';

class HiveScheduleRepository implements ScheduleRepository {
  late Box<Schedule> _scheduleBox;

  @override
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ScheduleAdapter());
      _scheduleBox = await Hive.openBox<Schedule>('scheduleBox');
    }
  }

  @override
  Future<List<Schedule>> getAllSchedules() async {
    return _scheduleBox.values.toList();
  }

  @override
  Future<List<Schedule>> getSchedulesByTrainer(String trainerId) async {
    return _scheduleBox.values
        .where((schedule) => schedule.trainerId == trainerId)
        .toList();
  }

  @override
  Future<List<Schedule>> getSchedulesByDateAndTrainer(
    DateTime date,
    Trainer trainer,
  ) async {
    return _scheduleBox.values.where((schedule) {
      return schedule.trainerId == trainer.id &&
          schedule.startTime.year == date.year &&
          schedule.startTime.month == date.month &&
          schedule.startTime.day == date.day;
    }).toList();
  }

  @override
  Future<List<Schedule>> getPastSchedulesByTrainer(Trainer trainer) async {
    final now = DateTime.now();
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainerId == trainer.id &&
              schedule.startTime.isBefore(now),
        )
        .toList();
  }

  @override
  Future<List<Schedule>> getUpcomingSchedulesByTrainer(Trainer trainer) async {
    final now = DateTime.now();
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainerId == trainer.id &&
              schedule.startTime.isAfter(now),
        )
        .toList();
  }

  @override
  Future<bool> saveSchedule(Schedule schedule) async {
    try {
      await _scheduleBox.add(schedule);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateSchedule(Schedule schedule) async {
    try {
      await schedule.save();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteSchedule(Schedule schedule) async {
    try {
      await schedule.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveSchedules(List<Schedule> schedules) async {
    try {
      await _scheduleBox.addAll(schedules);
      return true;
    } catch (e) {
      throw Exception('Failed to save schedules: $e');
    }
  }
}
