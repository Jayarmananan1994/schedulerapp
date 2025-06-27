import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';
import 'package:schedulerapp/service/storage_service.dart';

class ScheduleEditDetailModal extends StatefulWidget {
  final ScheduleDto schedule;
  const ScheduleEditDetailModal({super.key, required this.schedule});

  @override
  State<ScheduleEditDetailModal> createState() =>
      _ScheduleEditDetailModalState();
}

class _ScheduleEditDetailModalState extends State<ScheduleEditDetailModal> {
  bool _isChanged = false;
  final _storageService = GetIt.I<StorageService>();
  late Trainer selectedTrainer;
  late Trainee selectedTrainee;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat timeFormat = DateFormat('hh:mm a');

  @override
  void initState() {
    selectedTrainer = widget.schedule.trainer;
    selectedTrainee = widget.schedule.trainee;
    selectedDate = widget.schedule.startTime;
    selectedTime = TimeOfDay.fromDateTime(widget.schedule.startTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [appBar(), scheduleDetailContent()]);
  }

  appBar() {
    return Material(
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.only(top: 52),
        padding: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            Text(
              'Schedule Detail',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: _isChanged ? _saveChanges : null,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  _saveChanges() {
    // _storageService.updateSchedule(
    //   widget.schedule.copyWith(
    //     startTime: DateTime(
    //       selectedDate.year,
    //       selectedDate.month,
    //       selectedDate.day,
    //       selectedTime.hour,
    //       selectedTime.minute,
    //     ),
    //     trainer: selectedTrainer,
    //     trainee: selectedTrainee,
    //   ),
    // );
  }

  scheduleDetailContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
      child: Column(
        children: [
          traineeDropDown(),
          trainerDropDown(),
          scheduleDate(),
          startTime(),
        ],
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
              if (value != null) {
                setState(() => selectedTrainee = value);
              }
              if (selectedTrainee != widget.schedule.trainee) {
                setState(() => _isChanged = true);
              }
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

  trainerDropDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder<List<Trainer>>(
        future: _storageService.getTrainerList(),
        builder: (context, snapshot) {
          return DropdownButtonFormField<Trainer>(
            value: snapshot.hasData ? selectedTrainer : null,
            items:
                (snapshot.hasData)
                    ? snapshot.data!
                        .map(
                          (trainer) => DropdownMenuItem(
                            value: trainer,
                            child: Text(trainer.name),
                          ),
                        )
                        .toList()
                    : [],
            onChanged:
                snapshot.hasData
                    ? (value) {
                      if (value != null) {
                        setState(() => selectedTrainer = value);
                      }
                      if (selectedTrainer != widget.schedule.trainer) {
                        setState(() => _isChanged = true);
                      }
                    }
                    : null,
            decoration: InputDecoration(
              labelText: 'Select Trainer',
              border: OutlineInputBorder(),
            ),
          );
        },
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
              initialDate: widget.schedule.startTime,
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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
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
          child: Text(selectedTime.format(context)),
        ),
      ),
    );
  }
}
