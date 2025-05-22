import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/entity/staff.dart';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title(),
                  // SizedBox(height: 32),
                  stats(),
                  SizedBox(height: 16),
                  staffList(),
                  SizedBox(height: 16),
                ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statItem(Icons.groups, 'Staff', '12', 'Active Members'),
        _statItem(Icons.groups_2, 'Trainees', '48', 'Active Members'),
      ],
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

  staffList() {
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
                  onPressed: () {},
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

  _staffList() {
    var list = [
      Staff(id: '12', name: 'Sarah Johnson', payRate: 40),
      Staff(id: '13', name: 'Mike Johnson', payRate: 35),
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
                        width: 48,
                        height: 48,
                        child: CircleAvatar(child: Text(staff.name[0])),
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
}
