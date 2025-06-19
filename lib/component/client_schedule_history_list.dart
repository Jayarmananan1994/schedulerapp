import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/component/schedule_detail_modal.dart';
import 'package:schedulerapp/data/models/schedule.dart';
import 'package:schedulerapp/service/storage_service.dart';

class ClientScheduleHistoryList extends StatelessWidget {
  final String clientId;
  final _storageService = GetIt.I<StorageService>();
  final DateFormat _dateFormat = DateFormat('dd MMM yy');
  ClientScheduleHistoryList({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final pastSessions = _storageService.getTraineePastSessions(clientId);
    return ListView.builder(
      itemCount: pastSessions.length,
      itemBuilder: (context, index) {
        Schedule session = pastSessions[index];
        return ListTile(
          title: Text(
            'Trainer: ${session.trainer.name} @ ${_dateFormat.format(session.startTime)}',
          ),
          subtitle: Text(
            '${_dateFormat.format(session.startTime)} @ ${session.location}',
          ),
          onTap: () => _showScheduleDetails(session, context),
        );
      },
    );
  }

  _showScheduleDetails(schedule, context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Schedule Details'),
            content: ScheduleDetailModal(schedule: schedule),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
