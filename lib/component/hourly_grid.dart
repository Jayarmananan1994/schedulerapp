import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';

List<List<List<String>>> timeSlotMap = [
  [
    ["12:00 AM", "12:30 AM", "01:00 AM", "01:30 AM"],
    ["02:00 AM", "02:30 AM", "03:00 AM", "03:30 AM"],
  ],
  [
    ["04:00 AM", "04:30 AM", "05:00 AM", "05:30 AM"],
    ["06:00 AM", "06:30 AM", "07:00 AM", "07:30 AM"],
  ],
  [
    ["08:00 AM", "08:30 AM", "09:00 AM", "09:30 AM"],
    ["10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM"],
  ],

  [
    ["12:00 PM", "12:30 PM", "01:00 PM", "01:30 PM"],
    ["02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM"],
  ],

  [
    ["04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM"],
    ["06:00 PM", "06:30 PM", "07:00 PM", "07:30 PM"],
  ],
  [
    ["08:00 PM", "08:30 PM", "09:00 PM", "09:30 PM"],
    ["10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM"],
  ],
];

class HourlyGrid extends StatefulWidget {
  final Function onSelect;
  final List<TimeOfDay> unavailable;
  final TimeOfDay? initialSelected;
  const HourlyGrid({
    super.key,
    required this.onSelect,
    required this.unavailable,
    this.initialSelected,
  });

  @override
  State<HourlyGrid> createState() => _HourlyGridState();
}

class _HourlyGridState extends State<HourlyGrid> {
  String? selectedTimeOption;

  @override
  Widget build(BuildContext context) {
    selectedTimeOption =
        (widget.initialSelected != null)
            ? convertTimeOfDayToString(widget.initialSelected!)
            : null;

    return SizedBox(
      height: 110,
      child: PageView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(child: _slideContainer(index));
        },
      ),
    );
  }

  _slideContainer(slideCount) {
    List<String> slotsOne = timeSlotMap[slideCount][0];
    List<String> slotsTwo = timeSlotMap[slideCount][1];
    return Column(
      children: [
        Row(children: slotsOne.map((slot) => _timeContainer(slot)).toList()),
        SizedBox(height: 10),
        Row(children: slotsTwo.map((slot) => _timeContainer(slot)).toList()),
      ],
    );
  }

  Widget _timeContainer(String timeLabel) {
    TimeOfDay time = convertStringToTimeOfDay(timeLabel);
    bool isUnavailable = widget.unavailable.contains(time);
    return Expanded(
      child: GestureDetector(
        onTap: isUnavailable ? null : () => _handleOnTimeSelect(timeLabel),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Container(
            height: 46,
            width: 78,
            decoration: BoxDecoration(
              color:
                  isUnavailable
                      ? colorgreyShadeThree
                      : (timeLabel == selectedTimeOption)
                      ? colorBlueshade
                      : colorShadowGrey,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color:
                    (timeLabel == selectedTimeOption)
                        ? colorLightBlue
                        : colorGray,
                width: 1,
              ),
            ),

            padding: EdgeInsets.all(5),
            child: Center(
              child: Text(
                timeLabel,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isUnavailable ? colorDisableGray : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleOnTimeSelect(String timeLabel) {
    setState(() => selectedTimeOption = timeLabel);
    if (selectedTimeOption != null) {
      widget.onSelect(convertStringToTimeOfDay(selectedTimeOption!));
    }
  }

  String convertTimeOfDayToString(TimeOfDay timeOfDay) {
    final hour =
        timeOfDay.hourOfPeriod < 10
            ? '0${timeOfDay.hourOfPeriod}'
            : '${timeOfDay.hourOfPeriod}';
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  TimeOfDay convertStringToTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(' ');
      if (parts.length != 2) {
        throw const FormatException('Invalid time format');
      }

      final timePart = parts[0];
      final period = parts[1].toUpperCase();

      final timeComponents = timePart.split(':');
      if (timeComponents.length != 2) {
        throw const FormatException('Invalid time format');
      }

      var hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        throw const FormatException('Invalid time values');
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      throw FormatException('Failed to parse time: $e');
    }
  }
}
