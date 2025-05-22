import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/service/storage_service.dart';

class DashboardScreen extends StatelessWidget {
  final _storageService = GetIt.I<StorageService>();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width - 40;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 75, 10, 10),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                scheduleStats(deviceWidth),
                SizedBox(width: 10),
                _todayDate(deviceWidth),
              ],
            ),
            SizedBox(height: 24),
            reminderList(),
          ],
        ),
      ),
    );
  }

  scheduleStats(double deviceWidth) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _schedulesToday(deviceWidth / 4),
            _otherScheduleStats(deviceWidth / 4),
          ],
        ),
      ],
    );
  }

  _schedulesToday(width) {
    //final deviceWidth = MediaQuery.of(context).size.width - 60;
    return SizedBox(
      width: width,
      height: width * 2,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade200],
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: _getSchedulesForTodayText()),
          ),
        ),
      ),
    );
  }

  _getSchedulesForTodayText() {
    int count = _storageService.getScheduleCountFor(DateTime.now());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count > 0 ? '$count' : 'No',
          style: GoogleFonts.aBeeZee(fontSize: 32),
        ),
        Text('Schedules', style: GoogleFonts.aBeeZee(fontSize: 12)),
      ],
    );
  }

  _otherScheduleStats(width) {
    int countOfClients = _storageService.getNoOfActiveClients();
    int noOfStaffs = _storageService.getNoOfTrainers();
    return Column(
      children: [
        SizedBox(
          width: width,
          height: width,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$countOfClients',
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                  ),
                  Text(' Client(s)'),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: width,
          height: width,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$noOfStaffs', style: GoogleFonts.aBeeZee(fontSize: 20)),
                  Text(' Staff(s)'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _todayDate(double deviceWidth) {
    var today = DateTime.now();
    return SizedBox(
      width: deviceWidth / 2,
      height: deviceWidth / 2,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month, size: 32),
                    Text(
                      '${today.day}',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'may 25',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  reminderList() {
    List<Map<String, String>> clients = [
      {
        "name": "Tan Wei Liang",
        "subtitle": "Last Session: ${_dateFormat.format(DateTime.now())}",
      },
      {
        "name": "Ahmad bin Abdullah",
        "subtitle": "Last Session: ${_dateFormat.format(DateTime.now())}",
      },
      {
        "name": "Lim Siew Min",
        "subtitle": "Last Session: ${_dateFormat.format(DateTime.now())}",
      },
      {"name": "Lee Mei Ling", "subtitle": "No of sessions pending: 01"},
      {"name": "Raja Kumar", "subtitle": "No of sessions pending: 02"},
    ];
    return Flexible(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Time to reminder you clients',
              style: GoogleFonts.aBeeZee(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(0),
                itemCount: 5,

                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.deepPurple[50],
                      child: Text(
                        clients[index]['name']![0],
                        style: GoogleFonts.aBeeZee(
                          fontSize: 24,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    title: Text(
                      clients[index]['name']!,
                      style: GoogleFonts.aBeeZee(
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      clients[index]['subtitle']!,
                      style: GoogleFonts.aBeeZee(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      onPressed:
                          () =>
                              _notifyCustomer(clients[index]['name']!, context),
                      icon: Icon(Icons.notifications, color: Colors.black54),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _notifyCustomer(name, context) async {
    var text =
        '''Hi $name! The sessions we did together, do let me know if there is any error thank you!!

            Paid 10 sessions (\$700) on 04/03/2025:
            1. 12/03/2025
            2. 15/03/2025
            3. 16/03/2025
            4. 19/03/2025
            5. 26/03/2025
            6. 29/03/2025
            7. 06/04/2025
            8. 09/04/2025
            9. 16/04/2025
            10. 19/04/2025
''';
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied Client alert message.')),
    );
  }
}
