import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/models/trainer.dart';

abstract class ScheduleRepository {
  Future<void> init();
  Future<List<Schedule>> getAllSchedules();
  Future<List<Schedule>> getSchedulesByTrainer(String trainerId);
  Future<List<Schedule>> getSchedulesByDateAndTrainer(
    DateTime date,
    Trainer trainer,
  );
  Future<List<Schedule>> getPastSchedulesByTrainer(Trainer trainer);
  Future<List<Schedule>> getUpcomingSchedulesByTrainer(Trainer trainer);
  Future<bool> saveSchedule(Schedule schedule);
  Future<bool> updateSchedule(Schedule schedule);
  Future<bool> deleteSchedule(Schedule schedule);
}
