import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/data/models/schedule.dart';

class ScheduleDetailModal extends StatefulWidget {
  final Schedule schedule;
  const ScheduleDetailModal({super.key, required this.schedule});

  @override
  State<ScheduleDetailModal> createState() => _ScheduleDetailModalState();
}

class _ScheduleDetailModalState extends State<ScheduleDetailModal> {
  DateFormat dateFormat = DateFormat('dd MMM yy HH:mm');
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(widget.schedule.title),
          subtitle: Text(
            '${dateFormat.format(widget.schedule.startTime)} - ${dateFormat.format(widget.schedule.endTime)}',
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text('Details'),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trainee: ${widget.schedule.trainee.name}'),
              Text('Trainer: ${widget.schedule.trainer.name}'),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text('Location'),
          subtitle: Text(widget.schedule.location ?? 'No location'),
        ),
      ],
    );
  }
}
