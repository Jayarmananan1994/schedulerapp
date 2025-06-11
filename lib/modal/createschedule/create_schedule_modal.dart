import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/component/date_time_selector.dart';
import 'package:schedulerapp/component/trainee_package_manager_widget.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/entity/gym_package.dart';
import 'package:schedulerapp/entity/schedule.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/entity/trainee.dart';
import 'package:schedulerapp/modal/createschedule/trainee_selection_widget.dart';
import 'package:schedulerapp/modal/createschedule/trainer_selection_widget.dart';
import 'package:schedulerapp/service/storage_service.dart';
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
  Staff? selectedTrainer;
  List<DateTime> selectedDates = [];
  GymPackage? selectedPackage;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat timeFormat = DateFormat('hh:mm a');
  //  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = GetIt.I<StorageService>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '1',
  );
  late Future<List<Staff>> _staffListFuture;
  late Future<List<Trainee>> _traineeListFuture;

  @override
  void initState() {
    _staffListFuture = _storageService.getStaffList();
    _traineeListFuture = _storageService.getTraineeList();
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
            onTraineeSelect: _onTraineeSelection,
            onPackageSelect: _onPackageSelection,
          ),
          //SizedBox(height: 16),
          TrainerSelectionWidget(onSelect: _onTrainerSelection),
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

  _onTrainerSelection(trainer) {
    print('Selected Trainer');
    selectedTrainer = trainer;
  }

  _onTraineeSelection(Trainee trainee) {
    print('Selected Trainee ${trainee.name}');
    selectedTrainee = trainee;
  }

  _onPackageSelection(package) {
    print('Selected Package: ${package.name}');
    selectedPackage = package;
  }

  addSchdeuleContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              traineeDropDown(),
              SizedBox(height: 16),
              selectedTrainee != null
                  ? TraineePackageManagerWidget(
                    trainee: selectedTrainee!,
                    onPackageSelect: (val) => selectedPackage = val,
                  )
                  : Container(),
              SizedBox(height: selectedTrainee != null ? 16 : 0),
              trainerDropDown(),
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
        ),
      ),
    );
  }

  titleText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  startTime() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed:
            () => showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then((value) {
              if (value != null) {
                setState(() {
                  selectedTime = value;
                });
              }
            }),
        child: Text(
          selectedTime != null
              ? selectedTime!.format(context)
              : 'Select Start Time',
        ),
      ),
    );
  }

  hourTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextFormField(
        controller: _durationController,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {});
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a duration';
          }
          final duration = int.tryParse(value);
          if (duration == null || duration <= 0) {
            return 'Please enter a valid duration';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Duration in Hrs:',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  traineeDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Trainee',
          style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
        ),

        SizedBox(height: 16),
        FutureBuilder<List<Trainee>>(
          future: _traineeListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading trainees'));
            }
            List<Trainee> trainees = snapshot.data!;
            return SizedBox(
              height: 100,
              width: double.infinity,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final trainee = trainees[index];
                  bool isSelectedTrainee = selectedTrainee == trainee;
                  return GestureDetector(
                    onTap:
                        () => setState(
                          () =>
                              selectedTrainee =
                                  isSelectedTrainee ? null : trainee,
                        ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      height: isSelectedTrainee ? 60 : 70,
                      decoration: BoxDecoration(
                        color:
                            isSelectedTrainee
                                ? Color(0xffEFF6FF)
                                : Colors.white,
                        borderRadius:
                            isSelectedTrainee
                                ? BorderRadius.circular(10)
                                : BorderRadius.zero,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              backgroundColor: colorBlue,
                              child: Text(
                                trainees[index].name[0],
                                style: GoogleFonts.inter(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            trainees[index].name,
                            style: GoogleFonts.inter(
                              color: colorblack,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 5),
                itemCount: trainees.length,
              ),
            );
          },
        ),
      ],
    );
  }

  trainerDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Trainer',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 16),
        FutureBuilder<List<Staff>>(
          future: _staffListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading trainees'));
            }
            List<Staff> trainers = snapshot.data!;
            return SizedBox(
              height: 100,
              width: double.infinity,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final trainer = trainers[index];
                  bool isSelectedTrainee = selectedTrainer == trainer;
                  return GestureDetector(
                    onTap:
                        () => setState(
                          () =>
                              selectedTrainer =
                                  isSelectedTrainee ? null : trainer,
                        ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      height: isSelectedTrainee ? 60 : 70,
                      decoration: BoxDecoration(
                        color:
                            isSelectedTrainee
                                ? Color(0xffEFF6FF)
                                : Colors.white,
                        borderRadius:
                            isSelectedTrainee
                                ? BorderRadius.circular(10)
                                : BorderRadius.zero,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              backgroundColor: colorBlue,
                              child: Text(
                                trainers[index].name[0],
                                style: GoogleFonts.inter(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            trainers[index].name,
                            style: GoogleFonts.inter(
                              color: colorblack,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 5),
                itemCount: trainers.length,
              ),
            );
          },
        ),
      ],
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

    if (selectedTrainee != null &&
        selectedTrainer != null &&
        selectedDates.isNotEmpty &&
        selectedPackage != null) {
      List<Schedule> newSchedules =
          selectedDates
              .map(
                (date) => Schedule(
                  id: UniqueKey().toString(),
                  startTime: date,
                  trainee: selectedTrainee!,
                  trainer: selectedTrainer!,
                  endTime: date.copyWith(
                    hour: date.hour + 1,
                    minute: date.minute,
                  ),
                  trainerCost: selectedTrainer!.payRate,
                  traineeFee: selectedTrainee!.feePerSession,
                  packageId: selectedPackage!.id,
                  location: _locationController.text,
                ),
              )
              .toList();
      await _storageService.addSchedules(newSchedules);
      await selectedPackage!.deductSession(newSchedules.length);

      showCupertinoDialog(
        context: context,
        builder:
            (context) => CupertinoAlertDialog(
              title: Text('Success'),
              content: Text('Schedule saved successfully.'),
              actions: [
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
      ).then((_) {
        Navigator.pop(context, true);
      });
    }
  }
}
