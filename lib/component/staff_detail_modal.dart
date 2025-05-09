import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/model/schedule.dart';
import 'package:schedulerapp/model/staff.dart';
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
            SizedBox(height: 20),
            options(),
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
              icon: const Icon(Icons.close),
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
          'Pay Rate: \$${staff.payRate.toString()}',
          style: const TextStyle(fontSize: 18),
        ),

        Text('Total Pay: \$ 100.00', style: const TextStyle(fontSize: 18)),
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
              var dormatter = DateFormat('h:mm a');
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scheduleList.length,
                itemBuilder: (context, index) {
                  final schedule = scheduleList[index];
                  return ListTile(
                    title: Text(
                      '${schedule.trainee.name}@ ${schedule.location}',
                    ),
                    subtitle: Text(
                      '${dormatter.format(schedule.startTime)} - ${dormatter.format(schedule.endTime)}',
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
}
