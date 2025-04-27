import 'package:flutter/material.dart';
import 'package:schedulerapp/component/month_day_selector.dart';
import 'package:schedulerapp/component/time_scroll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: MediaQuery.of(context).padding,
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Column(
          children: [
            calendarIconRow(context),
            MonthDaySelector(
              selectedDay: selectedDate,
              onDateSelected: (date) => setState(() => selectedDate = date),
            ),
            TimeScroll(selectedDay: selectedDate),
          ],
        ),
      ),
    );
  }

  calendarIconRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => _showCalendar(context),
          icon: Icon(Icons.calendar_today),
        ),
      ],
    );
  }

  Future<void> _showCalendar(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Header color
              onPrimary: Colors.white, // Header text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      print("Selected Date: $pickedDate");
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
