import 'package:flutter/material.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/dto/expiring_client_session.dart';
import 'package:schedulerapp/dto/gym_stats.dart';
import 'package:schedulerapp/dto/trainee_item_detail.dart';
import 'package:schedulerapp/entity/upcoming_session.dart';

abstract class StorageService {
  Future<void> init();

  Future<List<Trainer>> getTrainerList();
  List<UpcomingSession> getAllUpcomingSchedule();
  Future<List<TraineeItemDetail>> getTraineeDetailList();
  Future<List<Trainee>> getTraineeList();

  Future<bool> saveTrainee(Trainee trainee);
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

  GymStats getGymStats();

  Future<int> deleteAllStaff();

  Future<int> deleteAllTrainee();
  Future<int> deleteAllSchedules();
  Future<void> deleteAllData();
}
