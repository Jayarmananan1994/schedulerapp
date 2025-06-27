import 'package:flutter/foundation.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/data/repositories/trainer_repository.dart';

class TrainerProvider with ChangeNotifier {
  final TrainerRepository _trainerRepository;
  List<Trainer>? _trainerList;
  bool _isLoading = false;
  String? _error;
  List<Trainer>? get trainerList => _trainerList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  TrainerProvider(this._trainerRepository) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _isLoading = true;
      _error = null;
      print('Starting to load trainers...');
      notifyListeners();
      _trainerList = await _trainerRepository.getAllTrainers();
      _isLoading = false;
      print('Trainers loaded successfully: ${_trainerList?.length}');
      notifyListeners();
    } catch (e) {
      print('Error loading trainers: $e');
      _isLoading = false;
      _error = 'Failed to load trainers';
      notifyListeners();
    }
  }

  deleteStaff(Trainer staff) {
    _trainerRepository
        .deleteTrainer(staff)
        .then((success) {
          if (success) {
            _trainerList?.remove(staff);
            notifyListeners();
          } else {
            _error = 'Failed to delete trainer';
            notifyListeners();
          }
        })
        .catchError((e) {
          _error = 'Error deleting trainer.';
          notifyListeners();
        });
  }

  addStaff(Trainer newTrainer) {
    return _trainerRepository
        .addTrainer(newTrainer)
        .then((success) {
          if (success) {
            _trainerList?.add(newTrainer);
            notifyListeners();
            return true;
          } else {
            _error = 'Failed to add trainer';
            notifyListeners();
            return false;
          }
        })
        .catchError((e) {
          _error = 'Error adding trainer.';
          notifyListeners();
          return false;
        });
  }
}
