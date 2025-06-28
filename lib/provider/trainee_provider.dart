import 'package:flutter/foundation.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/repositories/trainee_repository.dart';

class TraineeProvider with ChangeNotifier {
  List<Trainee> _trainees = [];
  String? _errorMessage;
  bool _isLoading = false;
  final TraineeRepository _traineeRepository;

  TraineeProvider(this._traineeRepository) {
    _loadTrainees();
  }

  List<Trainee> get trainees => _trainees;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void _loadTrainees() {
    _isLoading = true;
    notifyListeners();

    _traineeRepository
        .getAllTrainees()
        .then((trainees) {
          _trainees = trainees;
          _isLoading = false;
          notifyListeners();
        })
        .catchError((error) {
          _errorMessage = error.toString();
          _isLoading = false;
          notifyListeners();
        });
  }

  Future<void> saveTrainee(Trainee newTrainee) {
    _isLoading = true;
    notifyListeners();

    return _traineeRepository
        .addTrainee(newTrainee)
        .then((_) {
          _trainees.add(newTrainee);
          _isLoading = false;
          notifyListeners();
        })
        .catchError((error) {
          _errorMessage = "Failed to save trainee. Please try again.";
          _isLoading = false;
          notifyListeners();
        });
  }
}
