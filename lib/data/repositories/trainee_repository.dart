import '../models/trainee.dart';

abstract class TraineeRepository {
  Future<void> init();
  Trainee getTraineeById(String id);
  Future<List<Trainee>> getAllTrainees();
  Future<bool> addTrainee(Trainee trainee);
  Future<int> deleteAllTrainees();
}
