import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/service/storage_service.dart';

class TrainerProvider with ChangeNotifier {
  final StorageService _storageService = GetIt.I<StorageService>();
  List<Trainer>? _trainerList;

  List<Trainer>? get trainerList => _trainerList;

  Future<List<Trainer>> getTrainerList() async {
    _trainerList = await _storageService.getTrainerList();
    notifyListeners();
    return _trainerList!;
  }

  Future<void> deleteStaff(Trainer staff) async {
    await _storageService.deleteStaff(staff);
    await getTrainerList();
  }

  Future<void> addStaff(Trainer staff) async {
    await _storageService.saveTrainer(staff);
    await getTrainerList();
  }
}
