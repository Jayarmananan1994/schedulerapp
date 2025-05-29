import 'package:flutter/material.dart';
import 'package:schedulerapp/entity/gym_package.dart';
import 'package:schedulerapp/entity/schedule.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/entity/trainee.dart';

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
  List<Schedule> getTraineePastSessions(String clientId);
  List<Schedule> getTraineeUpcomingSessions(String clientId);
  Future<bool> updateSchedule(Schedule schedule);
  int getCountOfPastSessionsByTrainer(
    Staff staff,
    DateTime startOfMonth,
    DateTime endOfMonth,
  );
  int getCountOfPendingSessionsForTrainee(Trainee trainee);
  List<TimeOfDay> fetchBookedTimeForStaffByDate(
    Staff selectedTrainer,
    DateTime currentSelectedDate,
  );

  Future<bool> addNewPackageToTrainee(
    String packageName,
    int sessionPurchased,
    double price,
    String id,
  );

  List<GymPackage> getTraineeActivePackages(Trainee trainee);

  Future<bool> addSchedules(List<Schedule> schedules);

  int getScheduleCountFor(DateTime dateTime);

  int getNoOfActiveClients();

  int getNoOfTrainers();

  List<GymPackage> getPackageList();
}
