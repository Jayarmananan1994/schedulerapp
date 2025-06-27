import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/data/repositories/trainer_repository.dart';

class TrainerService {
  final TrainerRepository _trainerRepository;
  TrainerService(this._trainerRepository);
  List<Trainer> getTrainers() {
    return [];
  }

  Future<void> addTrainer(Trainer trainer) {
    return Future.value();
  }

  Future<void> deleteTrainer(Trainer trainer) {
    return Future.value();
  }

  Future<void> updateTrainer(Trainer trainer) {
    return Future.value();
  }

  Future<List<Trainer>> getAllTrainers() {
    return _trainerRepository.getAllTrainers();
  }
}
