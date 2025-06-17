import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/service/storage_service.dart';

class StaffProvider with ChangeNotifier {
  final StorageService _storageService = GetIt.I<StorageService>();
  List<Staff>? _staffList;

  List<Staff>? get staffList => _staffList;

  Future<List<Staff>> getStaffList() async {
    _staffList = await _storageService.getStaffList();
    notifyListeners();
    return _staffList!;
  }

  Future<void> deleteStaff(Staff staff) async {
    await _storageService.deleteStaff(staff);
    await getStaffList();
  }

  Future<void> addStaff(Staff staff) async {
    await _storageService.saveTrainer(staff);
    await getStaffList();
  }
}
