import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';

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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [monthTitle(), SizedBox(height: 12), monthDaysList()],
    );
  }

  monthTitle() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${months[widget.selectedDay.month - 1]}, ${widget.selectedDay.day}',
            style: GoogleFonts.inter(color: Colors.black, fontSize: 20),
          ),
          //const Spacer(),
          IconButton(
            onPressed: () => _showiOSCalendar(context),
            icon: Icon(CupertinoIcons.calendar),
          ),
        ],
      ),
    );
  }

  monthDaysList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: dayCounts(),
        itemBuilder: (context, index) {
          return numberButton((index + 1));
        },
      ),
    );
  }

  numberButton(int number) {
    return GestureDetector(
      onTap: () {
        widget.onDateSelected(
          DateTime(widget.selectedDay.year, widget.selectedDay.month, number),
        );
      },
      child: Container(
        width: 60,
        // height: 44,
        decoration: BoxDecoration(
          color:
              (number == widget.selectedDay.day)
                  ? colorBlueTwo
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayOfMonths(number.toString()),
              style: GoogleFonts.inter(
                fontSize: 12,
                color:
                    (number == widget.selectedDay.day)
                        ? Colors.white
                        : colorGreyTwo,
              ),
            ),
            SizedBox(height: 4),
            Text(
              number.toString(),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color:
                    (number == widget.selectedDay.day)
                        ? Colors.white
                        : colorGreyTwo,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
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

  _showiOSCalendar(BuildContext context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: <Widget>[
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: widget.selectedDay,
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime(2035),
                  onDateTimeChanged: (DateTime newDate) {
                    print('Selected date: $newDate');
                    // Update the selected date as the user scrolls
                    // setState(() {
                    //   _selectedDate = newDate;
                    // });
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () {
                  print('Selected date: ${widget.selectedDay}');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
