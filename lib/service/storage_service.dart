import 'package:schedulerapp/model/schedule.dart';
import 'package:schedulerapp/model/staff.dart';
import 'package:schedulerapp/model/trainee.dart';

abstract class StorageService {
  Future<void> init();
  List<Schedule> getScheduleItems(DateTime date);
  Future<List<Staff>> getStaffList();
  Future<List<Schedule>> getUpcomingSchedule(Staff staff, DateTime date);
  Future<List<Trainee>> getTraineeList();
  Future<bool> saveScheduleItem(Schedule schedule);
  Future<bool> saveTrainee(Trainee trainee);
  Future<bool> saveTrainer(Staff staff);
  Future<bool> deleteStaff(Staff id);
  //Future<void> addScheduleItem(Schedule schedule);
}
