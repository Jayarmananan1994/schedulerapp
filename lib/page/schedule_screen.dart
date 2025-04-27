import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/component/flexible_schdule_row.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final DateTime _selectedDay = DateTime.now();
  bool _showCalendar = false;
  final double _hourHeight = 150.0;
  final ScrollController _scrollController = ScrollController();

  final List<ScheduleItem> _scheduleItems = [
    ScheduleItem(
      title: 'Client Meeting',
      startTime: DateTime.now().copyWith(hour: 9, minute: 0),
      endTime: DateTime.now().copyWith(hour: 11, minute: 0),
      color: Colors.green.shade200,
    ),
    ScheduleItem(
      title: 'Client Meeting 2',
      startTime: DateTime.now().copyWith(hour: 9, minute: 0),
      endTime: DateTime.now().copyWith(hour: 10, minute: 0),
      color: Colors.red.shade300,
    ),
    ScheduleItem(
      title: 'Lunch Break',
      startTime: DateTime.now().copyWith(hour: 12, minute: 0),
      endTime: DateTime.now().copyWith(hour: 13, minute: 0),
      color: Colors.orange.shade200,
    ),
    ScheduleItem(
      title: 'Project Review',
      startTime: DateTime.now().copyWith(hour: 14, minute: 0),
      endTime: DateTime.now().copyWith(hour: 17, minute: 00),
      color: Colors.purple.shade200,
    ),
    ScheduleItem(
      title: 'Team Sync',
      startTime: DateTime.now().copyWith(hour: 16, minute: 0),
      endTime: DateTime.now().copyWith(hour: 16, minute: 45),
      color: Colors.red.shade200,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  void _scrollToCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour + (now.minute / 60);
    final offset = hour * _hourHeight - MediaQuery.of(context).size.height / 3;
    _scrollController.animateTo(
      offset.clamp(0.0, 23 * _hourHeight),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => setState(() => _showCalendar = !_showCalendar),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              DateFormat('EEEE, MMMM d, y').format(_selectedDay),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildTimeLines()),
        ],
      ),
    );
  }

  Widget _buildTimeLines() {
    final hourLines = List.generate(24, (index) {
      return SizedBox(
        height: _hourHeight,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${index.toString().padLeft(2, '0')}:00',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ),
        ),
      );
    });

    final scheduleItems = _getScheduleItemsForSelectedDay();
    scheduleItems.sort((a, b) => a.startTime.compareTo(b.startTime));

    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: 24 * _hourHeight,
        child: Stack(
          children: [
            Column(children: hourLines),
            for (final item in scheduleItems) _buildScheduleItemWidget(item),
          ],
        ),
      ),
    );
  }

  Widget scheduleTable(scheduleItems) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (final item in scheduleItems) _buildScheduleItemWidget(item),
      ],
    );
  }

  Widget _buildScheduleItemWidget(ScheduleItem item) {
    final startHour = item.startTime.hour + item.startTime.minute / 60;
    final endHour = item.endTime.hour + item.endTime.minute / 60;
    final duration = endHour - startHour;
    final top = startHour * _hourHeight;
    final height = duration * _hourHeight;
    print(
      'Start hour: ${item.startTime.hour}:${item.startTime.minute}, End hour: ${item.endTime.hour}:${item.endTime.minute}, Duration: $duration, top: $top, height: $height',
    );
    print(
      'Calculated height: $height, top: $top, duration: $duration, height: $height',
    );
    List<ScheduleItem> scheduleItems = [item];
    return Positioned(
      top: top,
      left: 60,
      right: 16,
      height: height,
      child: FlexibleSchduleRow(scheduleItems: scheduleItems),
    );
  }

  List<ScheduleItem> _getScheduleItemsForSelectedDay() {
    return _scheduleItems.where((item) {
      return item.startTime.year == _selectedDay.year &&
          item.startTime.month == _selectedDay.month &&
          item.startTime.day == _selectedDay.day;
    }).toList();
  }
}

class ScheduleItem {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  ScheduleItem({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}
