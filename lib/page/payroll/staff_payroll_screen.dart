import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/entity/staff_payroll.dart';
import 'package:schedulerapp/page/payroll/payroll_detail_widget.dart';

class StaffPayrollScreen extends StatefulWidget {
  const StaffPayrollScreen({super.key});

  @override
  State<StaffPayrollScreen> createState() => _StaffPayrollScreenState();
}

class _StaffPayrollScreenState extends State<StaffPayrollScreen> {
  DateFormat dateFormat = DateFormat('MMM yyyy');
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Staff Payroll',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: colorblack,
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.filter_alt_sharp, color: Colors.black),
          onPressed: () {},
        ),
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: CustomScrollView(
          slivers: [SliverFillRemaining(child: contentIos())],
        ),
      ),
    );
  }

  contentIos() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [monthOverviewDetail(), SizedBox(height: 32), staffList()],
        ),
      ),
    );
  }

  staffPayrollTitle() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Staff Payroll',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colorblack,
          ),
        ),
        IconButton(icon: Icon(Icons.filter), onPressed: () {}),
      ],
    );
  }

  content() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              monthOverviewDetail(),
              SizedBox(height: 16),
              staffList(),
            ],
          ),
        ),
      ),
    );
  }

  monthOverviewDetail() {
    var currentDate = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateFormat.format(currentDate),
            style: GoogleFonts.inter(
              color: colorgrey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '\$12,450',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: colorblack,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Total amount due this month',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: colorgrey,
            ),
          ),
        ],
      ),
    );
  }

  staffList() {
    var payrollList = [
      StaffPayroll(
        staff: Staff(id: '123', name: 'Sarah Johnson', payRate: 45),
        sessionCompleted: 20,
        upcomingSessionCount: 10,

        lastPaidDate: DateTime.now().copyWith(month: 4),
        lastMonthSessions: 38,
        lastMonthPaid: 1380,
        dueAmount: 1800,
      ),
      StaffPayroll(
        staff: Staff(id: '124', name: 'Michael Chen', payRate: 50),
        sessionCompleted: 22,
        upcomingSessionCount: 8,
        lastPaidDate: DateTime.now().copyWith(month: 4),
        lastMonthSessions: 30,
        lastMonthPaid: 1650,
        dueAmount: 1600,
      ),
      StaffPayroll(
        staff: Staff(id: '125', name: 'Emma Davis', payRate: 55),
        sessionCompleted: 18,
        upcomingSessionCount: 2,
        lastPaidDate: DateTime.now().copyWith(month: 4),
        lastMonthSessions: 24,
        lastMonthPaid: 1300,
        dueAmount: 1000,
      ),
    ];
    return Column(
      children:
          payrollList
              .map((payroll) => PayrollDetailWidget(staffPayroll: payroll))
              .toList(),
    );
  }
}
