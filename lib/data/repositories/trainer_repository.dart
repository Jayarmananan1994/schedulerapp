import '../models/trainer.dart';

abstract class TrainerRepository {
  Future<List<Trainer>> getAllTrainers();
  Future<bool> addTrainer(Trainer trainer);
  Future<bool> deleteTrainer(Trainer trainer);
  Future<int> deleteAllTrainers();
  int getTrainerCount();
}
