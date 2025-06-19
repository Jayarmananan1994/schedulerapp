import 'package:hive/hive.dart';
import '../../models/trainee.dart';
import '../../models/gym_package.dart';
import '../trainee_repository.dart';

class HiveTraineeRepository implements TraineeRepository {
  late Box<Trainee> _traineeBox;
  late Box<GymPackage> _packageBox;

  Future<void> init() async {
    _traineeBox = await Hive.openBox<Trainee>('traineeBox');
    _packageBox = await Hive.openBox<GymPackage>('packageBox');
  }

  @override
  Future<List<Trainee>> getAllTrainees() {
    return Future.value(_traineeBox.values.toList());
  }

  @override
  Future<bool> addTrainee(Trainee trainee) async {
    if (!_traineeBox.isOpen) return false;
    await _traineeBox.add(trainee);
    return true;
  }

  @override
  Future<bool> addPackage(GymPackage package) async {
    await _packageBox.add(package);
    return true;
  }

  @override
  Future<List<GymPackage>> getActivePackages(String traineeId) {
    return Future.value(
      _packageBox.values
          .where(
            (pkg) =>
                pkg.traineeId == traineeId && pkg.noOfSessionsAvailable > 0,
          )
          .toList(),
    );
  }

  @override
  Future<int> deleteAllTrainees() async {
    var response = await Future.wait([
      _traineeBox.clear(),
      _packageBox.clear(),
    ]);
    return response[0];
  }

  @override
  int getActiveTraineeCount() {
    Set<String> activeIds = <String>{};
    for (var package in _packageBox.values) {
      if (package.noOfSessionsAvailable > 0) {
        activeIds.add(package.traineeId);
      }
    }
    return activeIds.length;
  }
}
