import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/component/modal_app_bar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/model/schedule.dart';
import 'package:schedulerapp/model/staff.dart';
import 'package:schedulerapp/model/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';

class AddScheduleModal extends StatefulWidget {
  final DateTime defaultDateTime;
  const AddScheduleModal({super.key, required this.defaultDateTime});

  @override
  State<AddScheduleModal> createState() => _AddScheduleModalState();
}

class _AddScheduleModalState extends State<AddScheduleModal> {
  TimeOfDay? selectedTime;
  late DateTime selectedDate;
  Trainee? selectedTrainee;
  Staff? selectedTrainer;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat timeFormat = DateFormat('hh:mm a');
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = GetIt.I<StorageService>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '1',
  );

  @override
  void initState() {
    selectedDate = widget.defaultDateTime;
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
    return Column(
      children: [ModalAppBar(title: 'Add new Schdeule'), addSchdeuleContent()],
    );
  }

  addSchdeuleContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            traineeDropDown(),
            trainerDropDown(),
            scheduleDate(),
            startTime(),
            hourTextField(),
            locationTextField(),
            saveButton(),
          ],
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

  scheduleDate() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed:
            () => showDatePicker(
              context: context,
              initialDate: widget.defaultDateTime,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            ).then((value) {
              if (value != null) {
                setState(() => selectedDate = value);
              }
            }),
        child: Text(dateFormat.format(selectedDate)),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    return FutureBuilder<List<Trainee>>(
      future: _storageService.getTraineeList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading trainees'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No trainees available'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownButtonFormField<Trainee>(
            hint: const Text('Select Trainee'),
            value: selectedTrainee,
            items:
                snapshot.data!
                    .map(
                      (trainee) => DropdownMenuItem(
                        value: trainee,
                        child: Text(trainee.name),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() => selectedTrainee = value);
            },
            decoration: InputDecoration(
              labelText: 'Select Trainee',
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }

  // clientDropDown() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: FutureBuilder<List<Trainee>>(
  //       future: _storageService.getTraineeList(),
  //       builder: (context, snapshot) {
  //         return DropdownButtonFormField<Trainee>(
  //           hint: Text(
  //             snapshot.hasData ? 'Select an option' : 'Loading options...',
  //           ),
  //           value: snapshot.hasData ? selectedClient : null,
  //           items:
  //               (snapshot.hasData)
  //                   ? snapshot.data!
  //                       .map(
  //                         (trainee) => DropdownMenuItem(
  //                           value: trainee,
  //                           child: Text(trainee.name),
  //                         ),
  //                       )
  //                       .toList()
  //                   : [],
  //           onChanged:
  //               snapshot.hasData ? (value) => selectedClient = value : null,
  //           decoration: InputDecoration(
  //             labelText: 'Select Client',
  //             border: OutlineInputBorder(),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  trainerDropDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder<List<Staff>>(
        future: _storageService.getStaffList(),
        builder: (context, snapshot) {
          return DropdownButtonFormField<Staff>(
            value: snapshot.hasData ? selectedTrainer : null,
            items:
                (snapshot.hasData)
                    ? snapshot.data!
                        .map(
                          (staff) => DropdownMenuItem(
                            value: staff,
                            child: Text(staff.name),
                          ),
                        )
                        .toList()
                    : [],
            onChanged:
                snapshot.hasData ? (value) => selectedTrainer = value : null,
            decoration: InputDecoration(
              labelText: 'Select Trainer',
              border: OutlineInputBorder(),
            ),
          );
        },
      ),
    );
  }

  locationTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _locationController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a location';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Location',
          border: OutlineInputBorder(),
        ),
      ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(onPressed: _saveSchedule, child: Text('Save')),
    );
  }

  void _saveSchedule() {
    if (_formKey.currentState!.validate() &&
        selectedTrainee != null &&
        selectedTrainer != null &&
        selectedTime != null) {
      Schedule schedule = Schedule(
        id: UniqueKey().toString(),
        startTime: selectedDate.copyWith(
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
        ),
        endTime: selectedDate.copyWith(
          hour: selectedTime!.hour + int.parse(_durationController.text),
          minute: selectedTime!.minute,
        ),
        location: _locationController.text,
        trainee: selectedTrainee!,
        trainer: selectedTrainer!,
        color:
            pastelColors[Random.secure().nextInt(pastelColors.length)]
                .toARGB32(),
      );

      _storageService.saveScheduleItem(schedule).then((value) {
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
      });
    }
  }
}
