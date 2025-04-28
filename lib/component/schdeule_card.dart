import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/model/schdeule.dart';

class SchdeuleCard extends StatelessWidget {
  final ScheduleItem scheduleItem;

  const SchdeuleCard({super.key, required this.scheduleItem});

  @override
  Widget build(BuildContext context) {
    return schdeuleCard(scheduleItem);
  }

  Widget schdeuleCard(ScheduleItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '${DateFormat('h:mm a').format(item.startTime)} - ${DateFormat('h:mm a').format(item.endTime)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
