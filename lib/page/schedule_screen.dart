import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/modal/createschedule/create_schedule_modal.dart';
import 'package:schedulerapp/component/month_day_selector.dart';
import 'package:schedulerapp/component/schdeule_card.dart';
import 'package:schedulerapp/entity/schedule.dart';
import 'package:schedulerapp/service/storage_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with AutomaticKeepAliveClientMixin {
  DateTime? _selectedDay;
  final double _hourHeight = 150.0;
  final ScrollController _scrollController = ScrollController();
  final StorageService _storageService = GetIt.instance<StorageService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
    _selectedDay = _selectedDay ?? DateTime.now();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Schedules',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: colorblack,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.plus_circle_fill, size: 30),
              onPressed:
                  () => _showAddScheduleWindow(), // _showActionsSheet(context),
            ),
            // IconButton(
            //   icon: const Icon(CupertinoIcons.calendar_today, size: 24),
            //   onPressed: _selectDate,
            // ),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 0.0,
                  bottom: 24.0,
                ),
                child: MonthDaySelector(
                  selectedDay: _selectedDay ?? DateTime.now(),
                  onDateSelected: _onDateSelected,
                ),
              ),
            ),
            SliverFillRemaining(child: iosContent()),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showAddScheduleWindow,
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  iosContent() {
    return SingleChildScrollView(child: _buildTimeLines());
  }

  content() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 52),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _selectDate,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: MonthDaySelector(
            selectedDay: _selectedDay ?? DateTime.now(),
            onDateSelected: _onDateSelected,
          ),
        ),
        Expanded(child: _buildTimeLines()),
      ],
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

  _onDateSelected(DateTime date) {
    print('Selected date: $date');
    setState(() {
      _selectedDay = date;
    });
    _scrollToCurrentTime();
  }

  void _scrollToCurrentTime() {
    final hour = _selectedDay!.hour + (_selectedDay!.minute / 60);
    final offset = hour * _hourHeight - MediaQuery.of(context).size.height / 3;
    _scrollController.animateTo(
      offset.clamp(0.0, 6 * _hourHeight),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  List<Schedule> _getScheduleItemsForSelectedDay() {
    return _storageService.getScheduleItems(
      DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day),
    );
  }

  _showAddScheduleWindow() {
    // showModalBottomSheet(
    //   isScrollControlled: true,
    //   context: context,
    //   builder:
    //       (context) => CreateScheduleModal(
    //         defaultDateTime: _selectedDay ?? DateTime.now(),
    //       ),
    // );
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true, // This is the key!
        builder:
            (BuildContext context) => CreateScheduleModal(
              defaultDateTime: _selectedDay ?? DateTime.now(),
            ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _selectDate() async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime?>(
      context: context,
      builder: (builderContext) {
        DateTime selectedDate = DateTime.now();
        return Container(
          height: MediaQuery.of(builderContext).copyWith().size.height / 3,
          color: CupertinoColors.systemBackground.resolveFrom(builderContext),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(builderContext, null),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed:
                        () => Navigator.pop(builderContext, selectedDate),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date, // Only show date
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() => selectedDate = newDateTime);
                  },
                  minimumDate: DateTime(2020),
                  maximumDate: DateTime(2030),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (picked != null && picked != _selectedDay) {
      setState(() => _selectedDay = picked);
      _scrollToCurrentTime();
    }
  }
}
