import '../models/trainee.dart';
import '../models/gym_package.dart';

abstract class TraineeRepository {
  Future<List<Trainee>> getAllTrainees();
  Future<bool> addTrainee(Trainee trainee);
  Future<bool> addPackage(GymPackage package);
  Future<List<GymPackage>> getActivePackages(String traineeId);
  Future<int> deleteAllTrainees();
  int getActiveTraineeCount();
}
