import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayScrollWidget extends StatefulWidget {
  final Function onDateSelect;
  final DateTime? initialSelected;
  const DayScrollWidget({
    super.key,
    required this.onDateSelect,
    this.initialSelected,
  });

  @override
  State<DayScrollWidget> createState() => _DayScrollWidgetState();
}

class _DayScrollWidgetState extends State<DayScrollWidget> {
  final List<DateTime> _selectedDates = [];
  DateTime? _currentSelectedDate;

  final DateTime startDate =
      DateTime.now(); //DateTime(DateTime.now().year, 1, 1);
  final int totalDays =
      DateTime(
        DateTime.now().year + 1,
        1,
        1,
      ).difference(DateTime(DateTime.now().year, 1, 1)).inDays;

  @override
  void initState() {
    if (widget.initialSelected != null) {
      _selectedDates.add(widget.initialSelected!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
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
    bool isCurrentSelectedDate = date == _currentSelectedDate;

    return GestureDetector(
      onTap: () {
        if (isCurrentSelectedDate) {
          _currentSelectedDate = null;
          _selectedDates.remove(date);
        } else {
          _currentSelectedDate = date;
          if (!_selectedDates.contains(date)) {
            _selectedDates.add(date);
          }
        }
        widget.onDateSelect(_selectedDates, _currentSelectedDate);
        setState(() {});
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color:
              isCurrentSelectedDate
                  ? Colors.deepPurple[500]
                  : _selectedDates.contains(date)
                  ? Colors.deepPurple[100]
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
              DateFormat('EEE').format(date), // Day of week (Mon, Tue, etc.)
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              date.day.toString(), // Date
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('MMM').format(date), // Month (Jan, Feb, etc.)
              style: TextStyle(
                color:
                    _selectedDates.contains(date)
                        ? Colors.grey[900]
                        : Colors.grey,
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
}
