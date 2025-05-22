import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:schedulerapp/exception/schdule_conflict_exception.dart';
import 'package:schedulerapp/entity/gym_package.dart';
import 'package:schedulerapp/entity/schedule.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/entity/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:schedulerapp/util/app_util.dart';

class HiveStorageService implements StorageService {
  late Box<Staff> _staffBox;
  late Box<Trainee> _traineeBox;
  late Box<Schedule> _scheduleBox;
  late Box<GymPackage> _packageBox;

  @override
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      final dbDir = await path_provider.getApplicationDocumentsDirectory();
      Hive.init(dbDir.path);
      await Hive.initFlutter();
      Hive.registerAdapter(TraineeAdapter());
      Hive.registerAdapter(StaffAdapter());
      Hive.registerAdapter(ScheduleAdapter());
      Hive.registerAdapter(GymPackageAdapter());
      _staffBox = await Hive.openBox<Staff>('staffBox');
      _traineeBox = await Hive.openBox<Trainee>('traineeBox');
      _scheduleBox = await Hive.openBox<Schedule>('scheduleBox');
      _packageBox = await Hive.openBox<GymPackage>('packageBox');
    }
  }

  @override
  List<Schedule> getScheduleItems(DateTime date) {
    var schedules = _scheduleBox.values.toList();
    return schedules
        .where(
          (schedule) =>
              schedule.startTime.year == date.year &&
              schedule.startTime.month == date.month &&
              schedule.startTime.day == date.day,
        )
        .toList();
  }

  @override
  Future<List<Staff>> getStaffList() {
    return Future.value(_staffBox.values.toList());
  }

  @override
  Future<bool> deleteStaff(Staff staff) async {
    if (!_staffBox.isOpen) {
      return Future.value(false);
    }
    await staff.delete();
    return Future.value(true);
  }

  @override
  Future<List<Schedule>> getUpcomingSchedule(Staff staff, DateTime date) async {
    var upcomingSchedules =
        _scheduleBox.values.toList().where((schedule) {
          return schedule.trainer.name == staff.name &&
              schedule.startTime.isAfter(DateTime.now());
        }).toList();
    return Future.value(upcomingSchedules);
  }

  @override
  Future<List<Trainee>> getTraineeList() {
    return Future.value(_traineeBox.values.toList());
  }

  @override
  Future<bool> saveScheduleItem(Schedule schedule) async {
    _validateTraineeAndTrainerSchedule(schedule);
    await _scheduleBox.add(schedule);
    return Future.value(true);
  }

  @override
  Future<bool> saveTrainer(Staff staff) async {
    if (!_staffBox.isOpen) {
      return Future.value(false);
    }
    await _staffBox.add(staff);
    return Future.value(true);
  }

  @override
  Future<bool> saveTrainee(Trainee trainee) async {
    if (!_traineeBox.isOpen) {
      return Future.value(false);
    }
    await _traineeBox.add(trainee);
    return Future.value(true);
  }

  void _validateTraineeAndTrainerSchedule(Schedule schedule) {
    var schedules =
        _scheduleBox.values.where((scheduleItem) {
          return scheduleItem.trainer.name == schedule.trainer.name &&
              scheduleItem.intersects(schedule);
        }).toList();
    if (schedules.isNotEmpty) {
      throw ScheduleConflictException(
        'Schedule conflict! ${schedule.trainer.name} has another schedule at the same time.',
      );
    }
  }

  @override
  List<Schedule> getTraineePastSessions(String clientId) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainee.id == clientId &&
              schedule.startTime.isBefore(DateTime.now()),
        )
        .toList();
  }

  @override
  List<Schedule> getTraineeUpcomingSessions(String clientId) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainee.id == clientId &&
              (schedule.startTime.isAfter(DateTime.now())),
        )
        .toList();
  }

  @override
  Future<bool> updateSchedule(Schedule schedule) async {
    await schedule.save();
    return Future.value(true);
  }

  @override
  int getCountOfPastSessionsByTrainer(
    Staff staff,
    DateTime startOfMonth,
    DateTime endOfMonth,
  ) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainer.id == staff.id &&
              schedule.startTime.isAfter(startOfMonth) &&
              schedule.startTime.isBefore(endOfMonth) &&
              schedule.isLapsedSchedule(),
        )
        .length;
  }

  @override
  int getCountOfPendingSessionsForTrainee(Trainee trainee) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainee.id == trainee.id && schedule.isScheduleUnUsed(),
        )
        .length;
  }

  @override
  List<TimeOfDay> fetchBookedTimeForStaffByDate(
    Staff selectedTrainer,
    DateTime currentSelectedDate,
  ) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              isSameDate(currentSelectedDate, schedule.startTime) &&
              selectedTrainer == schedule.trainer,
        )
        .map((schedule) => TimeOfDay.fromDateTime(schedule.startTime))
        .toList();
  }

  @override
  Future<bool> addNewPackageToTrainee(
    int sessionPurchased,
    double price,
    String id,
  ) async {
    await _packageBox.add(
      GymPackage(
        UniqueKey().toString(),
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
    return _staffBox.length;
  }
}
