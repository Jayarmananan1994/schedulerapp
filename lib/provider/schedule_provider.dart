import 'package:flutter/cupertino.dart';
import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/repositories/gym_package_repository.dart';
import 'package:schedulerapp/data/repositories/schedule_repository.dart';
import 'package:schedulerapp/data/repositories/trainer_repository.dart';
import 'package:schedulerapp/data/repositories/trainee_repository.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';
import 'package:schedulerapp/enums/schedule_filter.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository _scheduleRepository;
  final TrainerRepository _trainerRepository;
  final TraineeRepository _traineeRepository;
  final GymPackageRepository _packageRepository;

  List<Schedule>? _schedules;
  String? _error;
  bool _isLoading = false;

  ScheduleProvider(
    this._scheduleRepository,
    this._trainerRepository,
    this._traineeRepository,
    this._packageRepository,
  ) {
    _loadSchedules();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ScheduleDto>? get schedules {
    if (_schedules == null) return null;
    return _schedules!.map(_createScheduleDto).toList();
  }

  ScheduleDto _createScheduleDto(Schedule schedule) {
    final trainer = _trainerRepository.getTrainerById(schedule.trainerId);
    final trainee = _traineeRepository.getTraineeById(schedule.traineeId);
    final package = _packageRepository.getPackageById(schedule.packageId);

    return ScheduleDto(
      schedule.id,
      schedule.title,
      schedule.startTime,
      schedule.endTime,
      trainee,
      trainer,
      schedule.meetingnote,
      schedule.location,
      package,
    );
  }

  Future<void> _loadSchedules() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _schedules = await _scheduleRepository.getAllSchedules();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to fetch schedules: ${e.toString()}';
      notifyListeners();
    }
  }

  List<ScheduleDto> getSchedulesForDate(DateTime date) {
    if (_schedules == null) return [];

    return _schedules!
        .where(
          (schedule) =>
              schedule.startTime.year == date.year &&
              schedule.startTime.month == date.month &&
              schedule.startTime.day == date.day,
        )
        .map(_createScheduleDto)
        .toList();
  }

  List<ScheduleDto> getSchedulesForTrainer(
    String trainerId,
    ScheduleFilter filter,
  ) {
    if (_schedules == null) return [];

    final trainerSchedules = _schedules!.where(
      (schedule) => schedule.trainerId == trainerId,
    );

    final now = DateTime.now();
    final filtered = switch (filter) {
      ScheduleFilter.today => trainerSchedules.where(
        (schedule) =>
            schedule.startTime.year == now.year &&
            schedule.startTime.month == now.month &&
            schedule.startTime.day == now.day,
      ),
      ScheduleFilter.upcoming => trainerSchedules.where(
        (schedule) => schedule.startTime.isAfter(now),
      ),
      ScheduleFilter.completed => trainerSchedules.where(
        (schedule) => schedule.startTime.isBefore(now),
      ),
      ScheduleFilter.all => trainerSchedules,
    };

    return filtered.map(_createScheduleDto).toList();
  }

  Future<void> refresh() => _loadSchedules();
}
