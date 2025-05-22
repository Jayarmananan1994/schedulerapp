import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class MonthDaySelector extends StatefulWidget {
  final DateTime selectedDay;
  final Function onDateSelected;

  const MonthDaySelector({
    super.key,
    required this.selectedDay,
    required this.onDateSelected,
  });

  @override
  State<MonthDaySelector> createState() => _MonthDaySelectorState();
}

class _MonthDaySelectorState extends State<MonthDaySelector> {
  late ScrollController _scrollController;
  final double _buttonWidth = 45.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
  }

  @override
  void didUpdateWidget(covariant MonthDaySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
      _scrollToSelectedDay();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [monthTitle(), monthDaysList()],
    );
  }

  monthTitle() {
    return SizedBox(
      height: 50,
      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      //padding: const EdgeInsets.only(top: 20),
      child: Text(
        months[widget.selectedDay.month - 1],
        style: GoogleFonts.inter(
          color: const Color.fromARGB(255, 59, 57, 57),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  monthDaysList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: dayCounts(),
          itemBuilder: (context, index) {
            return numberButton((index + 1));
          },
        ),
      ),
    );
  }

  numberButton(int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.green[800],
              onTap:
                  () => widget.onDateSelected(
                    DateTime(
                      widget.selectedDay.year,
                      widget.selectedDay.month,
                      number,
                    ),
                  ),
              child: Container(
                width: 45,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:
                      (number == widget.selectedDay.day)
                          ? Colors.green[800]
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color:
                          (number == widget.selectedDay.day)
                              ? Colors.white
                              : Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          dayOfMonths(number.toString()),

          style: const TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 108, 105, 105),
          ),
        ),
      ],
    );
  }

  dayCounts() {
    if ([1, 3, 5, 7, 8, 10, 12].contains(widget.selectedDay.month)) {
      return 31;
    } else if ([4, 6, 9, 11].contains(widget.selectedDay.month)) {
      return 30;
    } else if (widget.selectedDay.month == 2) {
      return (widget.selectedDay.year % 4 == 0) ? 29 : 28;
    }
  }

  dayOfMonths(String number) {
    DateTime date = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      int.parse(number),
    );
    String day = date.weekday.toString();
    switch (day) {
      case '1':
        return 'Mon';
      case '2':
        return 'Tue';
      case '3':
        return 'Wed';
      case '4':
        return 'Thu';
      case '5':
        return 'Fri';
      case '6':
        return 'Sat';
      case '7':
        return 'Sun';
      default:
        return '';
    }
  }

  _scrollToSelectedDay() {
    double selectedDayoffset = (widget.selectedDay.day - 1) * _buttonWidth;
    double totalViewPortWidth = _buttonWidth * 3.5;
    //double startVisible = _scrollController.offset;
    // double endVisible = startVisible + totalViewPortWidth;

    double scrollOffset =
        selectedDayoffset - (totalViewPortWidth / 2) + (_buttonWidth / 2);
    _scrollController.animateTo(
      scrollOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
