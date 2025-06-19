import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/dto/expiring_client_session.dart';
import 'package:schedulerapp/dto/gym_stats.dart';

import 'package:schedulerapp/dto/staff_payroll.dart';
import 'package:schedulerapp/dto/trainee_item_detail.dart';
import 'package:schedulerapp/entity/upcoming_session.dart';
import 'package:schedulerapp/exception/schdule_conflict_exception.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:schedulerapp/util/app_util.dart';
import 'package:collection/collection.dart';

class HiveStorageService implements StorageService {
  final DateFormat _todayDateFormat = DateFormat('hh:mm a');
  final DateFormat _dateFormat = DateFormat('dd MMM hh:mm');
  late Box<Trainer> _staffBox;
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
      Hive.registerAdapter(TrainerAdapter());
      Hive.registerAdapter(ScheduleAdapter());
      Hive.registerAdapter(GymPackageAdapter());
      _staffBox = await Hive.openBox<Trainer>('staffBox');
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
  Future<List<Trainer>> getTrainerList() {
    return Future.value(_staffBox.values.toList());
  }

  @override
  Future<bool> deleteStaff(Trainer staff) async {
    if (!_staffBox.isOpen) {
      return Future.value(false);
    }
    await staff.delete();
    List scheduleKeys =
        _scheduleBox
            .toMap()
            .entries
            .where((entry) => entry.value.id == staff.id)
            .map((entry) => entry.key)
            .toList();
    await _scheduleBox.deleteAll(scheduleKeys);
    return Future.value(true);
  }

  @override
  Future<List<Schedule>> getUpcomingSchedule(
    Trainer staff,
    DateTime date,
  ) async {
    return Future.value(_getUpcomingSchedule(staff, date));
  }

  List<Schedule> _getUpcomingSchedule(Trainer staff, DateTime date) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainer.name == staff.name &&
              schedule.startTime.isAfter(DateTime.now()),
        )
        .toList();
  }

  List<Schedule> _getCompletedSessionForLastMonth(Trainer staff) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainer.name == staff.name &&
              schedule.startTime.month == DateTime.now().month - 1 &&
              schedule.startTime.year == DateTime.now().year,
        )
        .toList();
  }

  List<Schedule> _getCurrentMonthCompletedSession(Trainer staff) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainer.name == staff.name &&
              schedule.startTime.isBefore(DateTime.now()) &&
              schedule.startTime.month == DateTime.now().month,
        )
        .toList();
  }

  List<Schedule> _getCurrentMonthUpcomingSessions(Trainer staff) {
    return _scheduleBox.values
        .where(
          (schedule) =>
              schedule.trainer.name == staff.name &&
              schedule.startTime.isAfter(DateTime.now()) &&
              schedule.startTime.month == DateTime.now().month,
        )
        .toList();
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
  Future<bool> saveScheduleItem(Schedule schedule) async {
    _validateTraineeAndTrainerSchedule(schedule);
    await _scheduleBox.add(schedule);
    return Future.value(true);
  }

  @override
  Future<bool> saveTrainer(Trainer staff) async {
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
    Trainer staff,
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
    Trainer selectedTrainer,
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
    return _staffBox.length;
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
  List<StaffPayroll> getPayrollDetailsOfAllStaff() {
    return _staffBox.values.map((staff) {
      var currentCompletedSessions = _getCurrentMonthCompletedSession(staff);
      var lastMonthCompletedSessions = _getCompletedSessionForLastMonth(staff);
      var currentUpcomingSessions = _getCurrentMonthUpcomingSessions(staff);
      return StaffPayroll(
        trainer: staff,
        sessionCompleted: currentCompletedSessions.length,
        upcomingSessionCount: currentUpcomingSessions.length,
        lastPaidDate: DateTime.now().subtract(Duration(days: 30)),
        lastMonthSessions: lastMonthCompletedSessions.length,
        lastMonthPaid: lastMonthCompletedSessions.length * staff.payRate,
        dueAmount: currentCompletedSessions.length * staff.payRate,
        upcomingSchedules: currentUpcomingSessions,
      );
    }).toList();
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
      _staffBox.clear(),
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
    return topSchedules.map((schedule) {
      String scheduleTime =
          istoday(schedule.startTime)
              ? _todayDateFormat.format(schedule.startTime)
              : _dateFormat.format(schedule.startTime);
      String title =
          _packageBox.values
              .firstWhere((sch) => sch.id == schedule.packageId)
              .name;

      return UpcomingSession(
        scheduleTime,
        title,
        "with ${schedule.trainer.name}",
        [
          schedule.trainee.imageUrl ?? schedule.trainee.name,
          schedule.trainer.imageUrl ?? schedule.trainer.name,
        ],
      );
    }).toList();
  }

  bool istoday(DateTime dateTime) {
    DateTime today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }
}
