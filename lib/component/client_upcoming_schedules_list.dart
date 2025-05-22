import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/entity/schedule.dart';
import 'package:schedulerapp/service/storage_service.dart';

class ClientUpcomingScheduleList extends StatelessWidget {
  final String clientId;
  final _storageService = GetIt.I<StorageService>();
  final DateFormat _dateFormat = DateFormat('dd MMM yy hh:mm a');
  ClientUpcomingScheduleList({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final upcomingSessions = _storageService.getTraineeUpcomingSessions(
      clientId,
    );
    upcomingSessions.sort((a, b) => a.startTime.compareTo(b.startTime));
    return ListView.builder(
      itemCount: upcomingSessions.length,
      itemBuilder: (context, index) {
        Schedule session = upcomingSessions[index];
        return ListTile(
          title: Text('Trainer: ${session.trainer.name}'),
          subtitle: Text(
            '${_dateFormat.format(session.startTime)} @ ${session.location!.isEmpty ? 'NA' : session.location}',
          ),
          trailing: Text('\$ ${session.traineeFee}'),
          onTap: () {},
        );
      },
    );
  }
}
