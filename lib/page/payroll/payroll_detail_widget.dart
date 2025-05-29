import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/entity/staff_payroll.dart';

class PayrollDetailWidget extends StatelessWidget {
  final StaffPayroll staffPayroll;
  const PayrollDetailWidget({super.key, required this.staffPayroll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 24, 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorShadowGrey, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [avatar(), SizedBox(width: 16), detailContent()],
      ),
    );
  }

  avatar() {
    return SizedBox(
      width: 48,
      height: 48,
      child: CircleAvatar(
        backgroundColor: colorBlue,
        child: Text('S', style: GoogleFonts.inter(color: Colors.white)),
      ),
    );
  }

  detailContent() {
    return Expanded(
      child: SizedBox(
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _instructorDetail(),
            instructorSessionDeatil(),
            previousMonthDetail(),
            upcomignSessions(),
            viewHistoryButton(),
          ],
        ),
      ),
    );
  }

  _instructorDetail() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              staffPayroll.staff.name,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: colorblack,
              ),
            ),
            Text(
              'Lead Trainer',
              style: GoogleFonts.inter(fontSize: 14, color: colorgrey),
            ),
          ],
        ),
        Container(
          width: 63,
          height: 24,
          color: colorWarningLight,
          child: Center(
            child: Text(
              'Pending',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colorWarning,
              ),
            ),
          ),
        ),
      ],
    );
  }

  instructorSessionDeatil() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sessions',
              style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
            ),
            SizedBox(height: 5),
            Text(
              '${staffPayroll.sessionCompleted}',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: colorblack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upcoming',
              style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
            ),
            SizedBox(height: 5),
            Text(
              '${staffPayroll.upcomingSessionCount}',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: colorblack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Amount Due',
              style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
            ),
            SizedBox(height: 5),
            Text(
              '\$ ${staffPayroll.dueAmount}',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: colorBlueTwo,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  previousMonthDetail() {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: colorShadowGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Previous Month: ',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorblack,
                ),
              ),
              Text(
                'Last month paid:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorGreyTwo,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '${staffPayroll.lastMonthSessions} sessions',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: colorGreyTwo,
                ),
              ),
              Text(
                '\$${staffPayroll.lastMonthPaid}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: colorblack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  upcomignSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Sessions',
          style: GoogleFonts.inter(
            color: colorblack,
            fontSize: 14,
            height: 1.42,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        ..._upcomingSessions(),
      ],
    );
  }

  _upcomingSessions() {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.calendar_month_outlined, color: colorGreyTwo),
            SizedBox(width: 5),
            Text(
              'July 15',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(width: 15),
            Icon(Icons.schedule_outlined, color: colorGreyTwo),
            SizedBox(width: 5),
            Text(
              '03:00 AM',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(width: 15),
            Text(
              '-  Tom R.',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.calendar_month_outlined, color: colorGreyTwo),
            SizedBox(width: 5),
            Text(
              'July 15',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(width: 15),
            Icon(Icons.schedule_outlined, color: colorGreyTwo),
            SizedBox(width: 5),
            Text(
              '10:00 AM',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(width: 15),
            Text(
              '-  Sarah P.',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    ];
  }

  viewHistoryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          //padding: const EdgeInsets.symmetric(vertical: 12),
          shadowColor: Colors.transparent,
          backgroundColor: colorShadowGrey,
          //foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'View Full History',
          style: GoogleFonts.inter(color: colorBlueTwo),
        ),
      ),
    );
  }
}
