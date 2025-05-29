import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/progress_bar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/modal/add_client/add_client_modal.dart';
import 'package:schedulerapp/modal/add_staff_modal.dart';

class GymManagementScreen extends StatelessWidget {
  const GymManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Gym Management',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: colorblack,
            ),
          ),
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
          slivers: [
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title(),
                    // SizedBox(height: 32),
                    stats(),
                    SizedBox(height: 16),
                    staffList(context),
                    SizedBox(height: 16),
                    traineeList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  title() {
    return Text(
      'Gym Management',
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: colorblack,
      ),
    );
  }

  stats() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(Icons.groups, 'Staff', '12', 'Active Members'),
          _statItem(Icons.groups_2, 'Trainees', '48', 'Active Members'),
        ],
      ),
    );
  }

  _statItem(icon, title, content, subtitle) {
    return Container(
      width: 170,
      height: 140,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colorShadowGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colorBlue),
              SizedBox(width: 5),
              Text(
                title,
                style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
              ),
            ],
          ),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
          ),
        ],
      ),
    );
  }

  staffList(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Staff Members',
                style: GoogleFonts.inter(
                  color: colorblack,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded edges,
                    ),
                  ),
                  onPressed: () => _showAddStaffPage(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'Add Staff',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _staffList(),
        ],
      ),
    );
  }

  _showAddStaffPage(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddStaffModal(),
      ),
    );
  }

  _showAddTraineePage(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddClientModal(),
      ),
    );
  }

  _staffList() {
    var list = [
      Staff(
        id: '12',
        name: 'Sarah Johnson',
        payRate: 40,
        imageUrl: 'assets/images/trainer2.png',
      ),
      Staff(
        id: '13',
        name: 'Mike Johnson',
        payRate: 35,
        imageUrl: 'assets/images/trainer1.png',
      ),
      Staff(
        id: '14',
        name: 'Choon wei',
        payRate: 35,
        imageUrl: 'assets/images/trainer3.png',
      ),
    ];
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var staff = list[index];
          return Container(
            width: 220,
            height: 160,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorShadowGrey,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(staff.imageUrl!),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {},
                          icon: Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  staff.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorblack,
                  ),
                ),
                Text(
                  'Head Trainer',
                  style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
                ),
                Text(
                  '\$${staff.payRate}/h',
                  style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemCount: list.length,
      ),
    );
  }

  traineeList(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trainees',
                style: GoogleFonts.inter(
                  color: colorblack,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 140,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => _showAddTraineePage(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'Add Trainee',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          //_staffList(),
          ..._trainerList(),
          //..._trainerList(),
        ],
      ),
    );
  }

  _trainerList() {
    var list = [
      Staff(
        id: '12',
        name: 'Sarah Johnson',
        payRate: 40,
        imageUrl: 'assets/images/trainer2.png',
      ),
      Staff(
        id: '13',
        name: 'Mike Johnson',
        payRate: 35,
        imageUrl: 'assets/images/trainer1.png',
      ),
      Staff(
        id: '14',
        name: 'Choon wei',
        payRate: 35,
        imageUrl: 'assets/images/trainer3.png',
      ),
    ];
    return list.map((staff) {
      return Container(
        width: double.infinity,
        height: 95,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorShadowGrey,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(staff.imageUrl!),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  staff.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorblack,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Trainee',
                  style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 280,
                  //width: double.infinity - 100,
                  child: ProgressBar(
                    progress: (8 / 10),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}
