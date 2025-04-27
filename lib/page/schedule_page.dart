import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Schedule App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SchedulePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data Model for a Schedule Entry
class ScheduleEntry {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  // Added for manual horizontal positioning to demonstrate adjacency
  final double leftPercent; // 0.0 to < 1.0
  final double widthPercent; // > 0.0 to 1.0

  ScheduleEntry({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.color = Colors.blueAccent,
    this.leftPercent = 0.0, // Default to full width
    this.widthPercent = 1.0, // Default to full width
  }) : assert(endTime.isAfter(startTime), 'End time must be after start time'),
       assert(leftPercent >= 0.0 && leftPercent < 1.0),
       assert(widthPercent > 0.0 && widthPercent <= 1.0),
       assert(leftPercent + widthPercent <= 1.0);

  // Helper to check if the entry is on a specific day
  bool isOnDay(DateTime day) {
    return startTime.year == day.year &&
        startTime.month == day.month &&
        startTime.day == day.day;
  }

  // Calculate duration in minutes
  int get durationInMinutes => endTime.difference(startTime).inMinutes;
}

// --- Main Schedule Screen Widget ---
class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDate = DateTime.now();
  final double _hourHeight = 80.0; // Height for each hour slot
  final double _hourLabelWidth = 50.0; // Width for the hour labels
  final ScrollController _scrollController = ScrollController();

  // --- Sample Schedule Data ---
  // In a real app, this would come from a database or API based on _selectedDate
  final List<ScheduleEntry> _allScheduleEntries = [
    // --- Today's Sample Data (adjust dates if needed) ---
    ScheduleEntry(
      id: '1',
      title: 'Morning Standup',
      startTime: DateTime.now().copyWith(
        hour: 9,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
      endTime: DateTime.now().copyWith(
        hour: 9,
        minute: 30,
        second: 0,
        millisecond: 0,
      ),
      color: Colors.lightBlue,
      leftPercent: 0.0, // Takes first half
      widthPercent: 0.5,
    ),
    ScheduleEntry(
      id: '2',
      title: 'Team Sync',
      startTime: DateTime.now().copyWith(
        hour: 9,
        minute: 15,
        second: 0,
        millisecond: 0,
      ),
      endTime: DateTime.now().copyWith(
        hour: 10,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
      color: Colors.amber,
      leftPercent: 0.5, // Takes second half
      widthPercent: 0.5,
    ),
    ScheduleEntry(
      id: '3',
      title: 'Client Call A',
      startTime: DateTime.now().copyWith(
        hour: 11,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
      endTime: DateTime.now().copyWith(
        hour: 11,
        minute: 45,
        second: 0,
        millisecond: 0,
      ),
      color: Colors.green,
      leftPercent: 0.0, // Takes first third
      widthPercent: 0.33,
    ),
    ScheduleEntry(
      id: '4',
      title: 'Internal Review B',
      startTime: DateTime.now().copyWith(
        hour: 11,
        minute: 15,
        second: 0,
        millisecond: 0,
      ),
      endTime: DateTime.now().copyWith(
        hour: 12,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
      color: Colors.orange,
      leftPercent: 0.33, // Takes second third
      widthPercent: 0.33,
    ),
    ScheduleEntry(
      id: '5',
      title: 'Focus Work C',
      startTime: DateTime.now().copyWith(
        hour: 11,
        minute: 30,
        second: 0,
        millisecond: 0,
      ),
      endTime: DateTime.now().copyWith(
        hour: 12,
        minute: 30,
        second: 0,
        millisecond: 0,
      ),
      color: Colors.purpleAccent,
      leftPercent: 0.66, // Takes third third
      widthPercent: 0.34, // Fill remaining
    ),
    ScheduleEntry(
      id: '6',
      title: 'Lunch Break',
      startTime: DateTime.now().copyWith(
        hour: 13,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
      endTime: DateTime.now().copyWith(
        hour: 14,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
      color: Colors.redAccent,
      // Default left/width (0.0 / 1.0) - takes full width
    ),
    ScheduleEntry(
      id: '7',
      title: 'Afternoon Task',
      startTime: DateTime.now().copyWith(
        hour: 15,
        minute: 30,
        second: 0,
        millisecond: 0,
      ),
      endTime: DateTime.now().copyWith(
        hour: 17,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
      color: Colors.teal,
    ),

    // --- Tomorrow's Sample Data ---
    ScheduleEntry(
      id: '8',
      title: 'Planning Session',
      startTime: DateTime.now()
          .add(const Duration(days: 1))
          .copyWith(hour: 10, minute: 0, second: 0, millisecond: 0),
      endTime: DateTime.now()
          .add(const Duration(days: 1))
          .copyWith(hour: 11, minute: 30, second: 0, millisecond: 0),
      color: Colors.indigo,
    ),
  ];

  // Filter entries for the selected day
  List<ScheduleEntry> get _entriesForSelectedDay {
    return _allScheduleEntries
        .where((entry) => entry.isOnDay(_selectedDate))
        .toList();
  }

  // --- Date Picker Logic ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020), // Adjust range as needed
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Optional: Scroll timeline to a specific time (e.g., 8 AM) when date changes
        _scrollToTime(const TimeOfDay(hour: 8, minute: 0));
      });
      // In a real app, you would likely re-fetch data for the new date here
    }
  }

  // --- Helper to scroll the timeline ---
  void _scrollToTime(TimeOfDay time) {
    final double offset =
        (time.hour + time.minute / 60.0) * _hourHeight -
        _hourHeight * 2; // Scroll slighty above
    _scrollController.animateTo(
      offset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ), // Ensure stays within bounds
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    // Optional: Scroll to current time on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTime(TimeOfDay.now());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheduleAreaWidth =
        screenWidth - _hourLabelWidth - 16; // Account for padding/labels

    return Scaffold(
      // appBar: AppBar(title: Text("Schedule")), // Optional AppBar
      body: SafeArea(
        // Use SafeArea to avoid notches/system bars
        child: Column(
          children: [
            // --- Top Bar: Date Display and Calendar Button ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Selected Date Display
                  Text(
                    DateFormat(
                      'EEEE, MMMM d, yyyy',
                    ).format(_selectedDate), // Format the date
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Calendar Icon Button
                  IconButton(
                    icon: const Icon(Icons.calendar_today, size: 28),
                    tooltip: 'Select Date',
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // --- Scrollable Schedule Area ---
            // Expanded(
            //   child: SingleChildScrollView(
            //     controller: _scrollController,
            //     child: Container(
            //       // Add some horizontal padding for the whole timeline view
            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //       child: Stack(
            //         children: [
            //           // --- Background Hour Lines and Labels ---
            //           _buildTimeLines(),

            //           // --- Schedule Entry Cards ---
            //           // Positioned cards are placed relative to the Stack
            //           // We add paddingLeft to offset them past the hour labels
            //           Padding(
            //             padding: EdgeInsets.only(left: _hourLabelWidth),
            //             child: LayoutBuilder(
            //               // Use LayoutBuilder to get exact width
            //               builder: (context, constraints) {
            //                 final availableWidth = constraints.maxWidth;
            //                 return Stack(
            //                   children: _buildScheduleCards(availableWidth),
            //                 );
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget to Build Hour Lines and Labels ---
  Widget _buildTimeLines() {
    List<Widget> timeLines = [];
    for (int i = 0; i < 24; i++) {
      timeLines.add(
        Container(
          height: _hourHeight,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1.0),
              // Optional: Add bottom border to last item if needed
              // bottom: i == 23 ? BorderSide(color: Colors.grey.shade300, width: 1.0) : BorderSide.none,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align label to top
            children: [
              // Hour Label
              SizedBox(
                width: _hourLabelWidth,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                    right: 4.0,
                  ), // Adjust padding
                  child: Text(
                    // Format hour (e.g., 9 AM, 1 PM, 12 AM)
                    DateFormat('h a').format(DateTime(0, 1, 1, i)),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ),
              // The rest of the space is for the schedule items (handled by the Stack overlay)
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    // Add one last border at the bottom (representing the start of the next day/midnight)
    timeLines.add(
      Container(
        height: 1, // Just the border height
        margin: EdgeInsets.only(
          left: _hourLabelWidth,
        ), // Align with schedule area
        color: Colors.grey.shade300,
      ),
    );

    // Wrap lines in a Column
    return Column(children: timeLines);
  }

  // --- Helper Widget to Build Schedule Cards ---
  List<Widget> _buildScheduleCards(double availableWidth) {
    List<Widget> scheduleCards = [];

    for (final entry in _entriesForSelectedDay) {
      // Calculate vertical position (top offset)
      final topOffset =
          (entry.startTime.hour + (entry.startTime.minute / 60.0)) *
          _hourHeight;

      // Calculate height based on duration
      final durationHours = entry.durationInMinutes / 60.0;
      final cardHeight = durationHours * _hourHeight;

      // Calculate horizontal position and width using pre-defined percentages
      // NOTE: This is a simplified approach for adjacency. A real-world app
      // would need a more complex algorithm to dynamically calculate overlaps
      // and assign left/width percentages.
      final cardLeft = availableWidth * entry.leftPercent;
      final cardWidth =
          availableWidth * entry.widthPercent - 2; // Subtract small gap

      scheduleCards.add(
        Positioned(
          top: topOffset,
          left: cardLeft,
          width: cardWidth,
          height: cardHeight.clamp(
            20.0,
            double.infinity,
          ), // Minimum height for visibility
          child: Card(
            color: entry.color.withOpacity(0.85), // Slightly transparent
            elevation: 2.0,
            margin: const EdgeInsets.only(
              top: 1.0,
              bottom: 1.0,
              right: 1,
            ), // Minimal margin inside Positioned
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                entry.title,
                style: const TextStyle(color: Colors.white, fontSize: 11),
                overflow: TextOverflow.ellipsis, // Handle text overflow
                maxLines: 2,
              ),
            ),
          ),
        ),
      );
    }

    return scheduleCards;
  }
}
