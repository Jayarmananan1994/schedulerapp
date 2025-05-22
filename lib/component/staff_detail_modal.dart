import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/entity/schedule.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/service/storage_service.dart';

class StaffDetailModal extends StatelessWidget {
  final Staff staff;
  final StorageService _storageService = GetIt.I<StorageService>();
  StaffDetailModal({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[appBar(context), Expanded(child: detailContent())],
    );
  }

  detailContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            staffDetail(staff),
            //SizedBox(height: 20),
            //options(),
            SizedBox(height: 30),
            upcomingSchedule(),
          ],
        ),
      ),
    );
  }

  appBar(context) {
    return Material(
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.only(top: 52),
        padding: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 50),
            const Text(
              'Trainer Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.xmark),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }

  staffDetail(Staff staff) {
    double totalCostFromStartOfMonth = computeTotalCost(staff);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          staff.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Pay Rate: \$${staff.payRate.toString()} / Session',
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          'Current month\'s Earning: \$$totalCostFromStartOfMonth',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  upcomingSchedule() {
    Future<List<Schedule>> schedules = _storageService.getUpcomingSchedule(
      staff,
      DateTime.now(),
    );
    return Column(
      children: [
        Text(
          'Upcoming Schedules',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        FutureBuilder<List<Schedule>>(
          future: schedules,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No upcoming schedules.'));
            } else {
              final scheduleList = snapshot.data!;
              scheduleList.sort((a, b) => a.startTime.compareTo(b.startTime));
              var dateFormatter = DateFormat('d MMM y');
              var timeFormatter = DateFormat('h:mm a');
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scheduleList.length,
                itemBuilder: (context, index) {
                  final schedule = scheduleList[index];
                  return ListTile(
                    title: Text(
                      'with ${schedule.trainee.name} @ ${schedule.location!.isEmpty ? 'NA' : schedule.location}',
                    ),
                    subtitle: Text(
                      'on ${dateFormatter.format(schedule.startTime)}',
                    ),
                    trailing: Text(
                      timeFormatter.format(schedule.startTime),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  options() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          label: Text('Deactivate'),
          icon: Icon(Icons.remove_circle),
        ),
        Builder(
          builder: (context) {
            return ElevatedButton.icon(
              onPressed: () => _deleteStaff(context),
              label: Text('Delete'),
              icon: Icon(Icons.delete),
            );
          },
        ),
      ],
    );
  }

  void _deleteStaff(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Staff'),
          content: const Text('Are you sure you want to delete this staff?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _storageService.deleteStaff(staff);
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Staff deleted successfully')));

        Navigator.pop(context, true);
      }
    });
  }

  double computeTotalCost(Staff staff) {
    DateTime startOfMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    );
    DateTime endOfMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0,
    );

    final noOfSchedules = _storageService.getCountOfPastSessionsByTrainer(
      staff,
      startOfMonth,
      endOfMonth,
    );

    return noOfSchedules * staff.payRate;
  }
}
