import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/dto/expiring_client_session.dart';
import 'package:schedulerapp/dto/gym_stats.dart';
import 'package:schedulerapp/dto/trainee_item_detail.dart';
import 'package:schedulerapp/entity/upcoming_session.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:schedulerapp/util/app_util.dart';

class HiveStorageService implements StorageService {
  late Box<Trainer> _trainerBox;
  late Box<Trainee> _traineeBox;
  late Box<Schedule> _scheduleBox;
  late Box<GymPackage> _packageBox;

  @override
  Future<void> init() async {
    _trainerBox = await Hive.openBox<Trainer>('trainerBox');
    _traineeBox = await Hive.openBox<Trainee>('traineeBox');
    _scheduleBox = await Hive.openBox<Schedule>('scheduleBox');
    _packageBox = await Hive.openBox<GymPackage>('packageBox');
  }

  @override
  Future<List<Trainer>> getTrainerList() {
    return Future.value(_trainerBox.values.toList());
  }

  @override
  Future<List<Trainee>> getTraineeList() {
    return Future.value(_traineeBox.values.toList());
  }

  @override
  Future<List<TraineeItemDetail>> getTraineeDetailList() {
    List<TraineeItemDetail> list =
        _traineeBox.values
            .map(
              (trainee) => TraineeItemDetail(
                trainee: trainee,
                packages:
                    _packageBox.values
                        .where((package) => package.traineeId == trainee.id)
                        .toList(),
              ),
            )
            .toList();
    return Future.value(list);
  }

  @override
  Future<bool> saveTrainee(Trainee trainee) async {
    if (!_traineeBox.isOpen) {
      return Future.value(false);
    }
    await _traineeBox.add(trainee);
    return Future.value(true);
  }

  @override
  List<TimeOfDay> fetchBookedTimeForStaffByDate(
    Trainer selectedTrainer,
    DateTime currentSelectedDate,
  ) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              isSameDate(currentSelectedDate, schedule.startTime) &&
              selectedTrainer.id == schedule.trainerId,
        )
        .map((schedule) => TimeOfDay.fromDateTime(schedule.startTime))
        .toList();
  }

  @override
  Future<bool> addNewPackageToTrainee(
    String packageName,
    int sessionPurchased,
    double price,
    String id,
  ) async {
    await _packageBox.add(
      GymPackage(
        UniqueKey().toString(),
        packageName,
        sessionPurchased,
        price,
        sessionPurchased,
        id,
      ),
    );
    return Future.value(true);
  }

  @override
  List<GymPackage> getTraineeActivePackages(Trainee trainee) {
    return _packageBox.values
        .where(
          (pck) => pck.traineeId == trainee.id && pck.noOfSessionsAvailable > 0,
        )
        .toList();
  }

  @override
  Future<bool> addSchedules(List<Schedule> schedules) async {
    await _scheduleBox.addAll(schedules);
    return Future.value(true);
  }

  @override
  int getScheduleCountFor(DateTime dateTime) {
    return _scheduleBox.values
        .where(
          (val) =>
              isSameDate(val.startTime, dateTime) &&
              !val.isCancelled &&
              !val.isForfeited,
        )
        .length;
  }

  @override
  int getNoOfActiveClients() {
    Set<String> clientIds = <String>{};
    for (var package in _packageBox.values) {
      if (package.noOfSessionsAvailable > 0) {
        clientIds.add(package.traineeId);
      }
    }
    return clientIds.length;
  }

  @override
  int getNoOfTrainers() {
    return _trainerBox.length;
  }

  @override
  List<GymPackage> getPackageList() {
    return _packageBox.values
        .groupListsBy((package) => package.name)
        .values
        .map((group) => group.first)
        .toList();
  }

  @override
  List<ExpiringClientSession> fetchClientsWithExpiringSessions() {
    List<ExpiringClientSession> expiringSessions = [];
    for (var trainee in _traineeBox.values) {
      var activePackages = _getTraineePackages(trainee);
      for (var package in activePackages) {
        if (package.noOfSessionsAvailable <= 2 &&
            !containUnusedSchedule(package.id)) {
          expiringSessions.add(ExpiringClientSession(trainee, package));
        }
      }
    }
    return expiringSessions;
  }

  @override
  GymStats getGymStats() {
    return GymStats(
      totalTrainers: getNoOfTrainers(),
      totalActiveClients: getNoOfActiveClients(),
    );
  }

  @override
  Future<int> deleteAllStaff() async {
    var response = await Future.wait([
      _traineeBox.clear(),
      _scheduleBox.clear(),
    ]);
    return response[0];
  }

  @override
  Future<int> deleteAllTrainee() async {
    var response = await Future.wait([
      _traineeBox.clear(),
      _packageBox.clear(),
    ]);
    return response[0];
  }

  @override
  Future<int> deleteAllSchedules() {
    return _scheduleBox.clear();
  }

  @override
  Future<void> deleteAllData() {
    return Future.wait([
      _trainerBox.clear(),
      _traineeBox.clear(),
      _scheduleBox.clear(),
      _packageBox.clear(),
    ]);
  }

  List<GymPackage> _getTraineePackages(Trainee trainee) {
    return _packageBox.values
        .where((pck) => pck.traineeId == trainee.id)
        .toList();
  }

  containUnusedSchedule(packageId) {
    var count =
        _scheduleBox.values
            .where(
              (sch) => sch.packageId == packageId && sch.isScheduleUnUsed(),
            )
            .toList()
            .length;
    return count > 2;
  }

  @override
  List<UpcomingSession> getAllUpcomingSchedule() {
    List<Schedule> schedules =
        _scheduleBox.values
            .where((schedule) => schedule.startTime.isAfter(DateTime.now()))
            .toList();

    schedules.sort((a, b) => a.startTime.compareTo(b.startTime));
    List<Schedule> topSchedules =
        (schedules.length > 5) ? schedules.sublist(0, 5) : schedules;
    return _mapToUpcomigSessions(topSchedules);
  }

  List<UpcomingSession> _mapToUpcomigSessions(List<Schedule> topSchedules) {
    // return topSchedules.map((schedule) {
    //   String scheduleTime =
    //       istoday(schedule.startTime)
    //           ? _todayDateFormat.format(schedule.startTime)
    //           : _dateFormat.format(schedule.startTime);
    //   String title =
    //       _packageBox.values
    //           .firstWhere((sch) => sch.id == schedule.packageId)
    //           .name;

    //   return UpcomingSession(
    //     scheduleTime,
    //     title,
    //     "with ${schedule.trainer.name}",
    //     [
    //       schedule.trainee.imageUrl ?? schedule.trainee.name,
    //       schedule.trainer.imageUrl ?? schedule.trainer.name,
    //     ],
    //   );
    // }).toList();
    return [];
  }

  bool istoday(DateTime dateTime) {
    DateTime today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }
}
