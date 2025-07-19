import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/page/trainer_schedule_history/status_chip.dart';
import 'package:schedulerapp/util/app_util.dart';

class ScheduleCard extends StatelessWidget {
  final DateFormat dateFormat = DateFormat('dd MMM hh:mm a');
  final DateFormat timeFormat = DateFormat('hh:mm a');
  final String clientName;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String type;

  ScheduleCard({
    super.key,
    required this.clientName,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    bool isScheduleToday = isSameDate(startTime, DateTime.now());
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorGreyTwo.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isScheduleToday
                    ? '${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}'
                    : dateFormat.format(startTime),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              StatusChip(status: status),
            ],
          ),
          SizedBox(height: 8),
          Text(
            clientName,
            style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
          ),
          SizedBox(height: 4),
          Text(
            type,
            style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
          ),
        ],
      ),
    );
  }
}
