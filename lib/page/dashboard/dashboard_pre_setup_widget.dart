import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/component/progress_bar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/modal/add_client/add_client_modal.dart';
import 'package:schedulerapp/modal/add_staff_modal.dart';
import 'package:schedulerapp/modal/createschedule/create_schedule_modal.dart';
import 'package:schedulerapp/provider/schedule_provider.dart';
import 'package:schedulerapp/provider/trainee_provider.dart';
import 'package:schedulerapp/provider/trainer_provider.dart';

class DashboardPreSetupWidget extends StatelessWidget {
  const DashboardPreSetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStartedWidget(context),
            _trainerListWidget(context),
            _traineeListWidget(context),
            _scheduleWidget(context),
            _tipsWidget(),
          ],
        ),
      ),
    );
  }

  _getStartedWidget(context) {
    int noOfStepsCompleted = _getNoOfStepsCompleted(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: colorShadowGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get Started',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Setup progress',
                style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
              ),
              Text(
                '$noOfStepsCompleted / 3 steps completed',
                style: GoogleFonts.inter(fontSize: 14, color: colorblack),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: ProgressBar(
              progress: noOfStepsCompleted / 3,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  _trainerListWidget(context) {
    int noOfTrainer =
        Provider.of<TrainerProvider>(context, listen: false).trainerList.length;
    if (noOfTrainer > 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xffF0FDF4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff22C55E)),
                SizedBox(width: 8),
                Text(
                  'Trainer setup',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'You\'ve added $noOfTrainer staff members',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Completed',
              style: GoogleFonts.inter(color: Color(0xff16A34A), fontSize: 14),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: colorGray, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_2, color: colorBlueTwo),
              SizedBox(width: 18),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trainers',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'No Trainers added yet',
                    style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _showAddStaffPage(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorBlueTwo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Add Team Member',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _traineeListWidget(context) {
    int noOfTrainee =
        Provider.of<TraineeProvider>(context, listen: false).trainees.length;
    if (noOfTrainee > 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xffF0FDF4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff22C55E)),
                SizedBox(width: 8),
                Text(
                  'Trainee setup',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'You\'ve added $noOfTrainee Trainee  Clients',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Completed',
              style: GoogleFonts.inter(color: Color(0xff16A34A), fontSize: 14),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: colorGray, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.groups_rounded, color: colorBlueTwo),
              SizedBox(width: 18),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trainee Clients',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'No Trainee Clients added yet',
                    style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _showAddTraineePage(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorBlueTwo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Add Trainee',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _scheduleWidget(context) {
    int noOfSchdeules =
        Provider.of<ScheduleProvider>(
          context,
          listen: false,
        ).scheduleDto.length;
    if (noOfSchdeules > 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xffF0FDF4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff22C55E)),
                SizedBox(width: 8),
                Text(
                  'Schedule setup',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'You\'ve added $noOfSchdeules schedules',
              style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Completed',
              style: GoogleFonts.inter(color: Color(0xff16A34A), fontSize: 14),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: colorGray, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.groups_rounded, color: colorBlueTwo),
              SizedBox(width: 18),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Schedule',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'No schedules created yet',
                    style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _showAddScheduleWindow(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorBlueTwo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Add new Schedule',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _tipsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips to get started',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            '1. Add your Trainer members first',
            style: GoogleFonts.inter(fontSize: 14, color: colorgrey),
          ),
          SizedBox(height: 5),
          Text(
            '2. Add your Trainee and a package.',
            style: GoogleFonts.inter(fontSize: 14, color: colorgrey),
          ),
          SizedBox(height: 5),
          Text(
            '3. Create your first class schedule',
            style: GoogleFonts.inter(fontSize: 14, color: colorgrey),
          ),
        ],
      ),
    );
  }

  int _getNoOfStepsCompleted(context) {
    int noOfStepsCompleted = 0;
    int noOfTrainer =
        Provider.of<TrainerProvider>(context, listen: false).trainerList.length;
    int noOfTrainee =
        Provider.of<TraineeProvider>(context, listen: false).trainees.length;
    int noOfSchedule =
        Provider.of<ScheduleProvider>(
          context,
          listen: false,
        ).scheduleDto.length;
    if (noOfTrainee > 0) {
      noOfStepsCompleted++;
    }
    if (noOfTrainer > 0) {
      noOfStepsCompleted++;
    }
    if (noOfSchedule > 0) {
      noOfStepsCompleted++;
    }
    return noOfStepsCompleted;
  }

  _showAddStaffPage(BuildContext context) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddTrainerModal(),
      ),
    );
  }

  _showAddTraineePage(BuildContext context) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddClientModal(),
      ),
    );
  }

  _showAddScheduleWindow(context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true, // This is the key!
        builder:
            (BuildContext context) =>
                CreateScheduleModal(defaultDateTime: DateTime.now()),
      ),
    );
  }
}
