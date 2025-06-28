import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/dto/create_schedule_dto.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';
import 'package:schedulerapp/util/app_util.dart';

class ScheduleService {
  Future<List<ScheduleDto>> getSchedulesByTrainerId(String id) async {
    return [];
  }

  Future<List<ScheduleDto>> getSchedulesByClientId(String id) async {
    return [];
  }

  List<ScheduleDto> getSchedulesByDate(DateTime date) {
    return [];
  }

  List<ScheduleDto> getSchedulesByTrainerIdBetweenDate(
    String id,
    DateTime startDate,
    DateTime endDate,
  ) {
    // _scheduleRepository
    //     .getAllSchedules()
    //     .where(
    //       (schedule) =>
    //           schedule.trainerId == id &&
    //           schedule.startTime.isAfter(startDate) &&
    //           schedule.startTime.isBefore(endDate),
    //     )
    //     .toList();
    return [];
  }

  List<Schedule> createSchedule(List<CreateScheduleDto> scheduleDtos) {
    return scheduleDtos.map((dto) {
      return Schedule(
        id: generateUniqueId(),
        title:
            dto.title ??
            'Session by ${dto.trainer.name} with ${dto.trainee.name}',
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
}
