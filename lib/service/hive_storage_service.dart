import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:schedulerapp/exception/schdule_conflict_exception.dart';
import 'package:schedulerapp/model/schedule.dart';
import 'package:schedulerapp/model/staff.dart';
import 'package:schedulerapp/model/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';

class HiveStorageService implements StorageService {
  late Box<Staff> _staffBox;
  late Box<Trainee> _traineeBox;
  late Box<Schedule> _scheduleBox;

  @override
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      final dbDir = await path_provider.getApplicationDocumentsDirectory();
      Hive.init(dbDir.path);
      await Hive.initFlutter();
      Hive.registerAdapter(TraineeAdapter());
      Hive.registerAdapter(StaffAdapter());
      Hive.registerAdapter(ScheduleAdapter());
      _staffBox = await Hive.openBox<Staff>('staffBox');
      _traineeBox = await Hive.openBox<Trainee>('traineeBox');
      _scheduleBox = await Hive.openBox<Schedule>('scheduleBox');
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
    validateTraineeAndTrainerSchedule(schedule);
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

  void validateTraineeAndTrainerSchedule(Schedule schedule) {
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
}
