import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/model/schdeule.dart';

var schdeules = [
  ScheduleItem(
    id: 1,
    title: 'Client Meeting',
    startTime: DateTime.now().copyWith(hour: 9, minute: 0),
    endTime: DateTime.now().copyWith(hour: 11, minute: 0),
    color: Colors.green.shade200,
    participants: List.empty(growable: true),
  ),
  ScheduleItem(
    id: 2,
    title: 'Client Meeting 2',
    startTime: DateTime.now().copyWith(hour: 9, minute: 0),
    endTime: DateTime.now().copyWith(hour: 10, minute: 0),
    color: Colors.red.shade300,
    participants: List.empty(growable: true),
  ),
];

class TimeScroll extends StatefulWidget {
  final DateTime selectedDay;
  const TimeScroll({super.key, required this.selectedDay});

  @override
  State<TimeScroll> createState() => _TimeScrollState();
}

class _TimeScrollState extends State<TimeScroll> {
  late ScrollController _scrollController;
  static const double _timeCardHeight = 130.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToStartOfWorkingDay(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TimeScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
      _scrollToStartOfWorkingDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            itemCount: 24,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => hourCard(index),
          ),
        ],
      ),
    );
  }

  hourCard(index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getHoutLabel(index),
                style: GoogleFonts.robotoCondensed(
                  fontSize: 24,
                  color: Color.fromARGB(255, 59, 57, 57),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getAmPmLabel(index),
                style: const TextStyle(
                  color: Color.fromARGB(255, 59, 57, 57),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned(top: -10, child: _scheduleCard(schdeules[0], index)),
              Container(
                height: _timeCardHeight,
                //width: 200,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white),
                    bottom:
                        (index == 23)
                            ? BorderSide(color: Colors.white)
                            : BorderSide.none,
                  ),
                ),
                padding: const EdgeInsets.only(top: 50, bottom: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _scrollToStartOfWorkingDay() {
    double offset = _timeCardHeight * 6.0; // 8 hours
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _scheduleCard(ScheduleItem schedule, int hour) {
    bool isHourSchdeuleStart = schedule.startTime.hour == hour;
    bool isHourSchdeuleEnd = schedule.endTime.hour == hour;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft:
                    isHourSchdeuleStart ? Radius.circular(20) : Radius.zero,
                topRight:
                    isHourSchdeuleStart ? Radius.circular(20) : Radius.zero,
                bottomLeft:
                    isHourSchdeuleEnd ? Radius.circular(20) : Radius.zero,
                bottomRight:
                    isHourSchdeuleEnd ? Radius.circular(20) : Radius.zero,
              ),
              color: schedule.color,
            ),
            height: _timeCardHeight,
            width: 200,
            //color: schedule.color,
            child: Column(children: [Text(schedule.id.toString())]),
          ),
        ],
      ),
    );
  }
}

String getHoutLabel(hourNumber) {
  int hourInNormalClock = hourNumber <= 12 ? hourNumber : hourNumber - 12;
  return hourInNormalClock < 10
      ? '0$hourInNormalClock:00'
      : '$hourInNormalClock:00';
}

String getAmPmLabel(hourNumber) {
  return hourNumber < 12 ? 'AM' : 'PM';
}
