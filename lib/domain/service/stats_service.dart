import 'package:schedulerapp/domain/service/trainee_service.dart';
import 'package:schedulerapp/domain/service/trainer_service.dart';
import 'package:schedulerapp/dto/gym_stats.dart';

class StatsService {
  final TraineeService _traineeService;
  final TrainerService _trainerService;

  StatsService(this._traineeService, this._trainerService);

  GymStats getGymStats() {
    final trainees = _traineeService.getActiveTrainees();
    final trainers = _trainerService.getTrainers();

    return GymStats(
      totalActiveClients: trainees.length,
      totalTrainers: trainers.length,
    );
  }
}
