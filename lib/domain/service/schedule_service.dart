import 'package:schedulerapp/data/models/schedule.dart';

abstract class ScheduleService {
  Future<List<Schedule>> getSchedules();
  Future<void> addSchedule(Schedule schedule);
  Future<void> deleteSchedule(Schedule schedule);
  Future<void> updateSchedule(Schedule schedule);
}
