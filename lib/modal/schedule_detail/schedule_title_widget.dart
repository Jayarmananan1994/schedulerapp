import 'package:flutter/material.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';

class ScheduleTitleWidget extends StatefulWidget {
  final ScheduleDto scheduleDto;
  const ScheduleTitleWidget({super.key, required this.scheduleDto});

  @override
  State<ScheduleTitleWidget> createState() => _ScheduleTitleWidgetState();
}

class _ScheduleTitleWidgetState extends State<ScheduleTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
