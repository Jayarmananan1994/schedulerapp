import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/dto/staff_payroll.dart';
import 'package:schedulerapp/page/payroll/payroll_detail_widget.dart';
import 'package:schedulerapp/service/storage_service.dart';

class StaffPayrollScreen extends StatefulWidget {
  const StaffPayrollScreen({super.key});

  @override
  State<StaffPayrollScreen> createState() => _StaffPayrollScreenState();
}

class _StaffPayrollScreenState extends State<StaffPayrollScreen> {
  DateFormat dateFormat = DateFormat('MMM yyyy');
  final StorageService _storageService = GetIt.instance<StorageService>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Trainer Payroll',
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
    List<StaffPayroll> staffPayroll =
        _storageService.getPayrollDetailsOfAllStaff();
    double totalAmt =
        staffPayroll.isEmpty
            ? 0
            : staffPayroll
                .map((payroll) => payroll.dueAmount)
                .reduce((a, b) => a + b);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            monthOverviewDetail(totalAmt),
            SizedBox(height: 32),
            staffList(staffPayroll),
          ],
        ),
      ),
    );
  }

  monthOverviewDetail(double amount) {
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
            '\$ $amount',
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

  staffList(List<StaffPayroll> staffPayroll) {
    return Column(
      children:
          staffPayroll
              .map((payroll) => PayrollDetailWidget(staffPayroll: payroll))
              .toList(),
    );
  }
}
