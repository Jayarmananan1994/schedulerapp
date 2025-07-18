import 'package:flutter/cupertino.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';
import 'package:schedulerapp/dto/staff_payroll.dart';
import 'package:schedulerapp/provider/schedule_provider.dart';
import 'package:schedulerapp/provider/trainer_provider.dart';

class PayrollProvider with ChangeNotifier {
  final ScheduleProvider _scheduleProvider;
  final TrainerProvider _trainerProvider;
  List<StaffPayroll>? _staffPayroll;
  bool _isLoading = false;
  String? _error;
  List<StaffPayroll>? get staffPayroll => _staffPayroll;
  bool get isLoading => _isLoading;
  String? get error => _error;
  PayrollProvider(this._scheduleProvider, this._trainerProvider) {
    _initialize();
    _trainerProvider.addListener(() {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _staffPayroll = [];
      for (final tr in _trainerProvider.trainerList) {
        var today = DateTime.now();
        List<ScheduleDto> schedulesCurrentMonth =
            _scheduleProvider.scheduleDto
                .where(
                  (s) =>
                      s.trainer.id == tr.id &&
                      s.startTime.year == today.year &&
                      s.startTime.month == today.month &&
                      !s.isCancelled,
                )
                .toList();
        List<ScheduleDto> schedulesLastMonth =
            _scheduleProvider.scheduleDto
                .where(
                  (s) =>
                      s.trainer.id == tr.id &&
                      s.startTime.year == today.year &&
                      s.startTime.month == today.month - 1 &&
                      !s.isCancelled,
                )
                .toList();

        var sessionCompleted =
            schedulesCurrentMonth.where((s) => s.isCompletedSchedule()).length;
        var upcomingSessionCount =
            schedulesCurrentMonth.where((s) => s.isScheduleUnUsed()).length;
        var lastPaidDate = DateTime.now().subtract(Duration(days: 30));
        var lastMonthSessions =
            schedulesLastMonth.where((s) => s.isCompletedSchedule()).length;
        var lastMonthPaid =
            schedulesLastMonth.where((s) => s.isCompletedSchedule()).length *
            tr.payRate;
        var dueAmount = sessionCompleted * tr.payRate;
        var payrollDtos = StaffPayroll(
          trainer: tr,
          sessionCompleted: sessionCompleted,
          upcomingSessionCount: upcomingSessionCount,
          lastPaidDate: lastPaidDate,
          lastMonthSessions: lastMonthSessions,
          lastMonthPaid: lastMonthPaid,
          dueAmount: dueAmount,
        );
        _staffPayroll!.add(payrollDtos);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load payroll data';
      notifyListeners();
    }
  }
}
