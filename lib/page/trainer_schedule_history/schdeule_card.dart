import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/page/trainer_schedule_history/status_chip.dart';

class ScheduleCard extends StatelessWidget {
  final String clientName;
  final String time;
  final String status;
  final String type;

  const ScheduleCard({
    super.key,
    required this.clientName,
    required this.time,
    required this.status,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorGreyTwo.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                clientName,
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
            time,
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
