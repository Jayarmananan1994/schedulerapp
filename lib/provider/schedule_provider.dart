import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/repositories/gym_package_repository.dart';
import 'package:schedulerapp/data/repositories/schedule_repository.dart';
import 'package:schedulerapp/data/repositories/trainer_repository.dart';
import 'package:schedulerapp/data/repositories/trainee_repository.dart';
import 'package:schedulerapp/dto/create_schedule_dto.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';
import 'package:schedulerapp/entity/upcoming_session.dart';
import 'package:schedulerapp/exception/schdeule_creation_exception.dart';
import 'package:schedulerapp/util/app_util.dart';

class ScheduleProvider with ChangeNotifier {
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
  List<ScheduleDto> get scheduleDto {
    if (_schedules == null) return [];
    return _schedules!.map(_createScheduleDto).toList();
  }

  List<UpcomingSession> get upcomingSessions {
    DateFormat dateFormat = DateFormat('dd MMM');
    DateFormat todayDateFormat = DateFormat('hh:mm a');
    return scheduleDto
        .where((schedule) => schedule.startTime.isAfter(DateTime.now()))
        .map((schedule) {
          String scheduleTime =
              _istoday(schedule.startTime)
                  ? todayDateFormat.format(schedule.startTime)
                  : dateFormat.format(schedule.startTime);
          String title = schedule.package.name;
          return UpcomingSession(
            title: title,
            subTitle: 'with ${schedule.trainer.name}',
            scheduleTime: scheduleTime,
            participants: [
              schedule.trainee.imageUrl ?? schedule.trainee.name,
              schedule.trainer.imageUrl ?? schedule.trainer.name,
            ],
          );
        })
        .toList();
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
      schedule.isCancelled,
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

  Future<void> refresh() => _loadSchedules();

  Future<Map> addSchedule(List<CreateScheduleDto> scheduleDto) async {
    try {
      _validateIfPackageAvailable(scheduleDto);
      final schedules = _createSchedule(scheduleDto);

      await _scheduleRepository.saveSchedules(schedules);

      await _loadSchedules();
      return {'result': true, 'message': 'Schedule added successfully'};
    } on SchdeuleCreationException catch (e) {
      notifyListeners();
      return {'result': false, 'message': e.message};
    } catch (e) {
      notifyListeners();
      return {
        'result': false,
        'message': 'Failed to add schedule. Please try again.',
      };
    }
  }

  List<Schedule> _createSchedule(List<CreateScheduleDto> scheduleDtos) {
    return scheduleDtos.map((dto) {
      return Schedule(
        id: generateUniqueId(),
        title:
            dto.title ??
            'Session by ${dto.trainee.name} with ${dto.trainer.name}',
        startTime: dto.startTime,
        endTime: dto.endTime,
        traineeId: dto.trainee.id,
        trainerId: dto.trainer.id,
        meetingnote: dto.meetingnote ?? '',
        location: dto.location,
        packageId: dto.package.id,
        traineeFee: dto.package.cost,
        trainerCost: dto.trainer.payRate,
      );
    }).toList();
  }

  void _validateIfPackageAvailable(List<CreateScheduleDto> schedule) {
    var packageMap = <String, Map>{};
    for (var dto in schedule) {
      if (packageMap.containsKey(dto.package.id)) {
        packageMap[dto.package.id]!['count'] += 1;
      } else {
        packageMap[dto.package.id] = {
          'availableCount': dto.package.noOfSessionsAvailable,
          'count': 1,
        };
      }
    }
    for (var entry in packageMap.entries) {
      final packageId = entry.key;
      final availableCount = entry.value['availableCount'] as int;
      final count = entry.value['count'] as int;

      if (availableCount < count) {
        throw SchdeuleCreationException(
          'Package $packageId does not have enough sessions available.',
        );
      }
    }
  }

  void cancelSchedule(String scheduleId) {
    final schedule = _schedules?.firstWhere(
      (s) => s.id == scheduleId,
      orElse: () => throw Exception('Schedule not found'),
    );

    if (schedule != null) {
      schedule.isCancelled = true;
      _scheduleRepository.updateSchedule(schedule);
      notifyListeners();
    } else {
      throw Exception('Schedule not found');
    }
  }

  Future<bool> updateSchedule(ScheduleDto scheduleDto) async {
    final schedule = _schedules?.firstWhere(
      (s) => s.id == scheduleDto.id,
      orElse: () => throw Exception('Schedule not found'),
    );

    if (schedule != null) {
      schedule.title = scheduleDto.title;
      schedule.startTime = scheduleDto.startTime;
      schedule.endTime = scheduleDto.endTime;
      schedule.trainerId = scheduleDto.trainer.id;
      schedule.meetingnote = scheduleDto.meetingnote;
      schedule.location = scheduleDto.location;
      schedule.packageId = scheduleDto.package.id;

      _scheduleRepository.updateSchedule(schedule);
      notifyListeners();
      return true;
    } else {
      throw Exception('Schedule not found');
    }
  }

  bool _istoday(DateTime dateTime) {
    DateTime today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }
}
