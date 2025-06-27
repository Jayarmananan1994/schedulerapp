import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/modal/add_staff_modal.dart';
import 'package:schedulerapp/provider/trainer_provider.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class TrainerListWidget extends StatelessWidget {
  final Function? onTrainerDeleted;

  const TrainerListWidget({super.key, this.onTrainerDeleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trainer Members',
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
                  onPressed: () => _showAddStaffPage(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'Add Trainer',
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
          _buildStaffList(),
        ],
      ),
    );
  }

  Widget _buildStaffList() {
    return Consumer<TrainerProvider>(
      builder: (context, staffProvider, child) {
        var list = staffProvider.trainerList;

        if (list == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (list.isEmpty) {
          return SizedBox(
            height: 160,
            child: Center(
              child: Text(
                'No staff available.',
                style: GoogleFonts.inter(fontSize: 16, color: colorGreyTwo),
              ),
            ),
          );
        }

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
                              onPressed: () => _deleteStaff(context, staff),
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
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: colorGreyTwo,
                      ),
                    ),
                    Text(
                      '\$${staff.payRate}/h',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: colorGreyTwo,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemCount: list.length,
          ),
        );
      },
    );
  }

  _deleteStaff(BuildContext context, Trainer staff) {
    showAppConfirmationDialog(
      context,
      'Confirmation',
      'Are you sure you want to delete ${staff.name}\'s record? Any schedule and history related to ${staff.name} will be removed.',
    ).then((val) async {
      if (val) {
        await Provider.of<TrainerProvider>(
          context,
          listen: false,
        ).deleteStaff(staff);
        await showAppInfoDialog(
          context,
          'Staff Remove',
          ' ${staff.name}\'s record is removed',
          'Ok',
          false,
        );
        if (onTrainerDeleted != null) {
          onTrainerDeleted!(true);
        }
      }
    });
  }

  _showAddStaffPage(BuildContext context) async {
    bool isCreated = await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddTrainerModal(),
      ),
    );
    if (isCreated) {
      if (onTrainerDeleted != null) {
        onTrainerDeleted!(true);
      }
    }
  }
}
