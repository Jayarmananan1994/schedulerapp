import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/data/repositories/schedule_repository.dart';
import 'package:schedulerapp/data/repositories/trainee_repository.dart';
import 'package:schedulerapp/dto/schedule_history_dto.dart';
import 'package:schedulerapp/util/app_util.dart';

class ScheduleService {
  final ScheduleRepository _scheduleRepository;
  final TraineeRepository _traineeRepository;

  ScheduleService(this._scheduleRepository, this._traineeRepository);

  Future<List<ScheduleHistoryDto>> getSchedulesByTrainerId(String id) async {
    return _scheduleRepository.getSchedulesByTrainer(id).then((schedules) {
      return schedules.map((schedule) => _createScheduleDto(schedule)).toList();
    });
  }

  Future<List<ScheduleHistoryDto>> getCurrentDaySchedulesByTrainerId(
    String id,
  ) {
    return _scheduleRepository.getSchedulesByTrainer(id).then((schedules) {
      return schedules
          .where((schedule) => isSameDate(schedule.startTime, DateTime.now()))
          .map((schedule) => _createScheduleDto(schedule))
          .toList();
    });
  }

  ScheduleHistoryDto _createScheduleDto(Schedule schedule) {
    final trainee = _traineeRepository.getTraineeById(schedule.traineeId);
    return ScheduleHistoryDto(
      id: schedule.id,
      trainee: trainee,
      trainerId: schedule.trainerId,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      isCancelled: schedule.isCancelled,
      isCompleted: schedule.isCompletedSchedule(),
    );
  }

  Future<List<ScheduleHistoryDto>> getUpcomingSchedulesByTrainerId(String id) {
    return _scheduleRepository.getSchedulesByTrainer(id).then((schedules) {
      return schedules
          .where(
            (schedule) => schedule.startTime.isAfter(
              DateTime.now().copyWith(day: DateTime.now().day + 1),
            ),
          )
          .map((schedule) => _createScheduleDto(schedule))
          .toList();
    });
  }

  Future<List<ScheduleHistoryDto>> getCompletedSchedulesByTrainerId(String id) {
    return _scheduleRepository.getSchedulesByTrainer(id).then((schedules) {
      return schedules
          .where((schedule) => schedule.isCompletedSchedule())
          .map((schedule) => _createScheduleDto(schedule))
          .toList();
    });
  }
}
