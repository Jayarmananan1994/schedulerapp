import 'package:flutter/material.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/dto/expiring_client_session.dart';
import 'package:schedulerapp/dto/gym_stats.dart';
import 'package:schedulerapp/dto/staff_payroll.dart';
import 'package:schedulerapp/dto/trainee_item_detail.dart';
import 'package:schedulerapp/entity/upcoming_session.dart';

abstract class StorageService {
  Future<void> init();
  List<Schedule> getScheduleItems(DateTime date);
  Future<List<Trainer>> getTrainerList();
  Future<List<Schedule>> getUpcomingSchedule(Trainer staff, DateTime date);
  List<UpcomingSession> getAllUpcomingSchedule();
  Future<List<TraineeItemDetail>> getTraineeDetailList();
  Future<List<Trainee>> getTraineeList();
  Future<bool> saveScheduleItem(Schedule schedule);
  Future<bool> saveTrainee(Trainee trainee);
  Future<bool> saveTrainer(Trainer staff);
  Future<bool> deleteStaff(Trainer staff);
  List<Schedule> getTraineePastSessions(String clientId);
  List<Schedule> getTraineeUpcomingSessions(String clientId);
  Future<bool> updateSchedule(Schedule schedule);
  int getCountOfPastSessionsByTrainer(
    Trainer staff,
    DateTime startOfMonth,
    DateTime endOfMonth,
  );
  int getCountOfPendingSessionsForTrainee(Trainee trainee);
  List<TimeOfDay> fetchBookedTimeForStaffByDate(
    Trainer selectedTrainer,
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

  List<ExpiringClientSession> fetchClientsWithExpiringSessions();

  List<StaffPayroll> getPayrollDetailsOfAllStaff();

  GymStats getGymStats();

  Future<int> deleteAllStaff();

  Future<int> deleteAllTrainee();
  Future<int> deleteAllSchedules();
  Future<void> deleteAllData();
}
