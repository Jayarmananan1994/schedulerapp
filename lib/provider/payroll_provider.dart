import 'package:flutter/foundation.dart';
import 'package:schedulerapp/dto/staff_payroll.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:get_it/get_it.dart';

class PayrollProvider with ChangeNotifier {
  final StorageService _storageService = GetIt.I<StorageService>();
  List<StaffPayroll> _payrollList = [];
  bool _isLoading = false;
  String? _error;

  List<StaffPayroll> get payrollList => _payrollList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPayrollData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _payrollList = _storageService.getPayrollDetailsOfAllStaff();
      _error = null;
    } catch (e) {
      _error = 'Failed to load payroll data: $e';
      if (kDebugMode) {
        print(_error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPayrollData() async {
    await loadPayrollData();
  }
}
