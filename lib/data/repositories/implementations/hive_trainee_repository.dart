import 'package:hive/hive.dart';
import '../../models/trainee.dart';
import '../trainee_repository.dart';

class HiveTraineeRepository implements TraineeRepository {
  late Box<Trainee> _traineeBox;

  @override
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TraineeAdapter());
      _traineeBox = await Hive.openBox<Trainee>('traineeBox');
    }
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
  Future<int> deleteAllTrainees() async {
    return _traineeBox.clear();
  }

  @override
  Trainee getTraineeById(String id) {
    if (!_traineeBox.isOpen) {
      throw Exception('Trainee box is not open');
    }
    final trainee = _traineeBox.values.firstWhere(
      (trainee) => trainee.id == id,
      orElse: () => throw Exception('Trainee not found'),
    );
    return trainee;
  }
}
