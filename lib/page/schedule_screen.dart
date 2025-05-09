import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/component/add_schedule_modal.dart';
import 'package:schedulerapp/component/schdeule_card.dart';
import 'package:schedulerapp/model/schedule.dart';
import 'package:schedulerapp/service/storage_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();
  final double _hourHeight = 150.0;
  final ScrollController _scrollController = ScrollController();
  final StorageService _storageService = GetIt.instance<StorageService>();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
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
      offset.clamp(0.0, 6 * _hourHeight),
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
            onPressed: _selectDate,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleWindow,
        child: Icon(Icons.add),
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
              alignment: Alignment.topLeft,
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
    //_getSchdeuleItems();
    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: 24 * _hourHeight,
        child: Stack(
          children: [
            Column(children: hourLines),
            ..._buildScheduleCards(scheduleItems),
          ],
        ),
      ),
    );
  }

  List<Schedule> _getSchdeuleItems() {
    final scheduleItems = _getScheduleItemsForSelectedDay();
    scheduleItems.sort((a, b) => a.startTime.compareTo(b.startTime));
    return scheduleItems;
  }

  List<Widget> _buildScheduleCards(List<Schedule> items) {
    if (items.isEmpty) {
      return [];
    }
    final deviceWidth = MediaQuery.of(context).size.width - 60;
    List<List<Schedule>> itemsSortedByTimes = [];
    List<Widget> scheduleCards = [];
    items.sort((a, b) => a.startTime.compareTo(b.startTime));
    List<Schedule> currentList = [items[0]];
    itemsSortedByTimes.add(currentList);
    for (int i = 1; i < items.length; i++) {
      if (currentList.first.intersects(items[i])) {
        currentList.add(items[i]);
      } else {
        currentList = [items[i]];
        itemsSortedByTimes.add(currentList);
      }
    }

    for (var listItems in itemsSortedByTimes) {
      double width = deviceWidth / listItems.length.toDouble();
      double leftPadding = 0;
      for (int i = 0; i < listItems.length; i++) {
        scheduleCards.add(
          _buildPositionedCardItem(listItems[i], width, leftPadding),
        );
        leftPadding += width;
      }
    }
    return scheduleCards;
  }

  Widget _buildPositionedCardItem(
    Schedule item,
    double width,
    double leftPadding,
  ) {
    final startHour = item.startTime.hour + item.startTime.minute / 60;
    final endHour = item.endTime.hour + item.endTime.minute / 60;
    final duration = endHour - startHour;
    final top = startHour * _hourHeight;
    final height = duration * _hourHeight;
    return Positioned(
      top: top,
      left: 60 + leftPadding,
      height: height,
      child: SizedBox(width: width, child: SchdeuleCard(scheduleItem: item)),
    );
  }

  List<Schedule> _getScheduleItemsForSelectedDay() {
    return _storageService.getScheduleItems(
      DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDay) {
      setState(() => _selectedDay = picked);
      _scrollToCurrentTime();
    }
  }

  _showAddScheduleWindow() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => AddScheduleModal(defaultDateTime: _selectedDay),
    );
  }
}
