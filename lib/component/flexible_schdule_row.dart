import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/page/schedule_screen.dart';

class FlexibleSchduleRow extends StatelessWidget {
  final List<ScheduleItem> scheduleItems;
  const FlexibleSchduleRow({super.key, required this.scheduleItems});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> containerItems = buildSchdeuleCards(scheduleItems);
        return Row(
          children:
              containerItems.map((item) => Expanded(child: item)).toList(),
        );
      },
    );
  }

  List<Widget> buildSchdeuleCards(List<ScheduleItem> scheduleItems) {
    return scheduleItems.map((item) => schdeuleCard(item)).toList();
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
