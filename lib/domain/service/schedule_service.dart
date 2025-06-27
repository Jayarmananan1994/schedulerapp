import 'package:schedulerapp/dto/schedule_dto.dart';

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
}
