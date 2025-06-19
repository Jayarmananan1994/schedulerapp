import 'package:hive/hive.dart';
import '../../models/trainer.dart';
import '../trainer_repository.dart';

class HiveTrainerRepository implements TrainerRepository {
  late Box<Trainer> _trainerBox;

  Future<void> init() async {
    _trainerBox = await Hive.openBox<Trainer>('trainerBox');
  }

  @override
  Future<List<Trainer>> getAllTrainers() {
    return Future.value(_trainerBox.values.toList());
  }

  @override
  Future<bool> addTrainer(Trainer trainer) async {
    if (!_trainerBox.isOpen) return false;
    await _trainerBox.add(trainer);
    return true;
  }

  @override
  Future<bool> deleteTrainer(Trainer trainer) async {
    if (!_trainerBox.isOpen) return false;
    await trainer.delete();
    return true;
  }

  @override
  Future<int> deleteAllTrainers() {
    return _trainerBox.clear();
  }

  @override
  int getTrainerCount() {
    return _trainerBox.length;
  }
}
