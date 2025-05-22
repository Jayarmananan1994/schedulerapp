import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/component/hourly_grid.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:schedulerapp/util/app_util.dart';
import 'package:collection/collection.dart';

class DateTimeSelector extends StatefulWidget {
  final Staff trainer;
  final Function onDateSelected;
  const DateTimeSelector({
    super.key,
    required this.trainer,
    required this.onDateSelected,
  });

  @override
  State<DateTimeSelector> createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  final List<DateTime> _selectedDateTimes = [];
  DateTime? _currentSelectedDate;
  final _storageService = GetIt.I<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [dateScroll(), SizedBox(height: 8), timeSlotScroll()],
    );
  }

  dateScroll() {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime(startDate.year + 1, 1, 1);
    int totalDays =
        endDate.difference(DateTime(DateTime.now().year, 1, 1)).inDays;

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalDays + 1,
        itemBuilder: (context, index) {
          if (index >= totalDays) {
            return _buildLoadingIndicator();
          }
          return _buildDayContainer(startDate.add(Duration(days: index)));
        },
      ),
    );
  }

  Widget _buildDayContainer(DateTime date) {
    bool isCurrentSelectedDate = isSameDate(date, _currentSelectedDate);
    bool isOneOfSelectedDate = checkIfSelectedDateHas(date);
    return GestureDetector(
      onTap: () {
        if (isCurrentSelectedDate) {
          _currentSelectedDate = null;
          _selectedDateTimes.removeWhere(
            (selectedDate) => isSameDate(selectedDate, date),
          );
          widget.onDateSelected(_selectedDateTimes);
        } else {
          _currentSelectedDate = date;
        }
        setState(() {});
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color:
              isCurrentSelectedDate
                  ? Colors.deepPurple[500]
                  : isOneOfSelectedDate
                  ? Color(0xffEFF6FF)
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrentSelectedDate ? Colors.white54 : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              date.day.toString(), // Date
              style: TextStyle(
                fontSize: 20,
                color: isCurrentSelectedDate ? Colors.white54 : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('MMM').format(date),
              style: TextStyle(
                color: isOneOfSelectedDate ? Colors.grey[900] : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  timeSlotScroll() {
    return _currentSelectedDate != null
        ? HourlyGrid(
          onSelect: _onTimeslotValueChange,
          unavailable: _timeSlotsToExlude(),
          initialSelected: _timeSelectedOfDate(_currentSelectedDate),
        )
        : Container();
  }

  List<TimeOfDay> _timeSlotsToExlude() {
    var unavaialableSlots = _storageService.fetchBookedTimeForStaffByDate(
      widget.trainer,
      _currentSelectedDate!,
    );
    if (isSameDate(_currentSelectedDate, DateTime.now())) {
      List<TimeOfDay> pastSlots = getTimeListUntilNow();
      unavaialableSlots.addAll(pastSlots);
    }
    return unavaialableSlots;
  }

  List<TimeOfDay> getTimeListUntilNow({int startHour = 0}) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;

    final timeList = <TimeOfDay>[];

    for (int hour = startHour; hour <= currentHour; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        if (hour < currentHour ||
            (hour == currentHour && minute <= currentMinute)) {
          timeList.add(TimeOfDay(hour: hour, minute: minute));
        }
      }
    }

    return timeList;
  }

  _onTimeslotValueChange(TimeOfDay val) {
    if (_currentSelectedDate == null) {
      return;
    }
    bool isDateAlreadyExist = checkIfSelectedDateHas(_currentSelectedDate!);
    if (isDateAlreadyExist) {
      _selectedDateTimes.removeWhere(
        (selectedDate) => isSameDate(_currentSelectedDate, selectedDate),
      );
    }
    _selectedDateTimes.add(
      DateTime(
        _currentSelectedDate!.year,
        _currentSelectedDate!.month,
        _currentSelectedDate!.day,
        val.hour,
        val.minute,
      ),
    );

    widget.onDateSelected(_selectedDateTimes);
    setState(() {});
  }

  bool checkIfSelectedDateHas(DateTime date) {
    return _selectedDateTimes.any(
      (selectedDate) => isSameDate(date, selectedDate),
    );
  }

  TimeOfDay? _timeSelectedOfDate(DateTime? currentSelectedDate) {
    if (currentSelectedDate == null) {
      return null;
    }

    DateTime? dateTime = _selectedDateTimes.firstWhereOrNull(
      (sld) => isSameDate(currentSelectedDate, sld),
    );

    return dateTime == null
        ? null
        : TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}
