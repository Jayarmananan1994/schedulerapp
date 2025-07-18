import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/component/date_time_selector.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/dto/create_schedule_dto.dart';
import 'package:schedulerapp/modal/createschedule/trainee_selection_widget.dart';
import 'package:schedulerapp/modal/createschedule/trainer_selection_widget.dart';
import 'package:schedulerapp/provider/gym_package_provider.dart';
import 'package:schedulerapp/provider/schedule_provider.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class CreateScheduleModal extends StatefulWidget {
  final DateTime defaultDateTime;
  const CreateScheduleModal({super.key, required this.defaultDateTime});

  @override
  State<CreateScheduleModal> createState() => _CreateScheduleModalState();
}

class _CreateScheduleModalState extends State<CreateScheduleModal> {
  TimeOfDay? selectedTime;
  Trainee? selectedTrainee;
  Trainer? selectedTrainer;
  List<DateTime> selectedDates = [];
  GymPackage? selectedPackage;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat timeFormat = DateFormat('hh:mm a');
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '1',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        middle: Text(
          'Create Schedule',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: addSchdeuleContentIos(),
            ),
          ],
        ),
      ),
    );
  }

  addSchdeuleContentIos() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TraineeSelectionWidget(
            onTraineeSelect: (trainee) => selectedTrainee = trainee,
            onPackageSelect: (package) => selectedPackage = package,
          ),
          TrainerSelectionWidget(
            onSelect: (trainer) => setState(() => selectedTrainer = trainer),
          ),
          SizedBox(height: 16),
          selectedTrainer != null
              ? DateTimeSelector(
                trainer: selectedTrainer!,
                onDateSelected: (datesSelected) {
                  selectedDates = datesSelected;
                },
              )
              : Container(),
          SizedBox(height: selectedTrainer != null ? 16 : 0),
          locationTextField(),
          SizedBox(height: 32),
          saveButton(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  locationTextField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location (Optional)',
          style: GoogleFonts.inter(
            color: colorBlackShadeFour,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        CupertinoTextField(
          controller: _locationController,
          placeholder: 'Enter location',
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(CupertinoIcons.location_solid, color: colorGray),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: colorGray),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          clearButtonMode: OverlayVisibilityMode.editing,
        ),
      ],
    );
  }

  meetingNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Meeting Note',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      //padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _saveSchedule,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff3B82F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded edges,
          ),
        ),
        child: Text(
          'Create Schedule',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _saveSchedule() async {
    if (selectedTrainee == null) {
      showAppInfoDialog(context, 'Error', 'Please select Trainee', 'Ok', true);
      return;
    }
    if (selectedTrainer == null) {
      showAppInfoDialog(context, 'Error', 'Please select Trainer', 'Ok', true);
      return;
    }
    if (selectedPackage == null) {
      showAppInfoDialog(
        context,
        'Error',
        'Please select a package',
        'Ok',
        true,
      );
      return;
    }
    if (selectedDates.isEmpty) {
      showAppInfoDialog(context, 'Error', 'Please select date(s)', 'Ok', true);
      return;
    }
    if (selectedDates.length > selectedPackage!.noOfSessionsAvailable) {
      showAppInfoDialog(
        context,
        'Error',
        'No of slots selected is more than avaialbe sessions',
        'Ok',
        true,
      );
      return;
    }

    if (_isFormValueValid()) {
      final createDtos =
          selectedDates
              .map(
                (dates) => CreateScheduleDto(
                  null,
                  selectedTrainer!,
                  selectedTrainee!,
                  dates,
                  dates.add(Duration(hours: 1)),
                  '',
                  _locationController.text,
                  selectedPackage!,
                ),
              )
              .toList();
      Map result = await Provider.of<ScheduleProvider>(
        context,
        listen: false,
      ).addSchedule(createDtos);
      Provider.of<GymPackageProvider>(
        context,
        listen: false,
      ).deductPackageAvailability(selectedPackage, selectedDates.length);

      showAppInfoDialog(
        context,
        result['result'] ? 'Success' : 'Error',
        result['result'] ? 'Schedule saved successfully.' : result['message'],
        'Ok',
        !result['result'],
      ).then((_) {
        if (result['result']) {
          Navigator.pop(context, true);
        }
      });
    }
  }

  bool _isFormValueValid() {
    return selectedTrainee != null &&
        selectedTrainer != null &&
        selectedDates.isNotEmpty &&
        selectedPackage != null;
  }
}
