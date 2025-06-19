import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/component/schedule_edit_detail_modal.dart';
import 'package:schedulerapp/data/models/schedule.dart';

class SchdeuleCard extends StatelessWidget {
  final Schedule scheduleItem;

  const SchdeuleCard({super.key, required this.scheduleItem});

  @override
  Widget build(BuildContext context) {
    return schdeuleCard(scheduleItem, context);
  }

  Widget schdeuleCard(Schedule item, context) {
    var title = _cardTitle(item);
    return Material(
      child: InkWell(
        onTap: () => _showScheduleDetails(item, context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: item.getColorByStatus(),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
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
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: title.length > 12 ? 12 : 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('h:mm a').format(item.startTime)} - ${DateFormat('h:mm a').format(item.endTime)}',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Expanded(child: Container()),
                avatarRow(item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cardTitle(item) {
    return item.title.isEmpty
        ? '${item.trainer.name} with ${item.trainee.name}@ ${item.location}'
        : item.title;
  }

  _showScheduleDetails(schedule, context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ScheduleEditDetailModal(schedule: schedule);
      },
    );
    // showDialog(
    //   context: context,

    //   builder:
    //       (context) => AlertDialog(
    //         title: const Text('Schedule Details'),
    //         content: ScheduleDetailModal(schedule: schedule),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text('Forfit'),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text('Cancel'),
    //           ),
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(),
    //             child: const Text('Close'),
    //           ),
    //         ],
    //       ),
    //   //      builder: (context) => ScheduleDetailModal(schedule: schedule),
    // );
  }

  avatarRow(Schedule item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //if (item.client != null)
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.blue,
          child: Text(item.trainee.name[0], style: TextStyle(fontSize: 10)),
        ),

        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.green,
          child: Text(item.trainer.name[0], style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}
