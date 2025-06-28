import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';

class CreateScheduleDto {
  final String? title;
  final Trainer trainer;
  final Trainee trainee;
  final DateTime startTime;
  final DateTime endTime;
  final String? meetingnote;
  final String? location;
  final GymPackage package;

  CreateScheduleDto(
    this.title,
    this.trainer,
    this.trainee,
    this.startTime,
    this.endTime,
    this.meetingnote,
    this.location,
    this.package,
  );
}
