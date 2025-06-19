import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/gogym_avatar.dart';
import 'package:schedulerapp/component/trainee_package_manager_widget.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';

class TraineeSelectionWidget extends StatefulWidget {
  final Function onTraineeSelect;
  final Function onPackageSelect;
  const TraineeSelectionWidget({
    super.key,
    required this.onTraineeSelect,
    required this.onPackageSelect,
  });

  @override
  State<TraineeSelectionWidget> createState() => _TraineeSelectionWidgetState();
}

class _TraineeSelectionWidgetState extends State<TraineeSelectionWidget> {
  Trainee? selectedTrainee;
  GymPackage? selectedPackage;
  final StorageService _storageService = GetIt.I<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Trainee',
          style: GoogleFonts.inter(
            color: colorBlackShadeFour,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        FutureBuilder<List<Trainee>>(
          future: _storageService.getTraineeList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No trainees available.'));
            } else {
              final trainees = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _traineeList(trainees),
                  SizedBox(height: 24),
                  _packageSelection(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  _traineeList(List<Trainee> trainees) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool isSelectedTrainee = selectedTrainee == trainees[index];
          return GestureDetector(
            onTap: () {
              widget.onTraineeSelect(trainees[index]);
              setState(() {
                selectedTrainee = trainees[index];
              });
            },
            child: Container(
              width: 80,
              height: 105,
              decoration: BoxDecoration(
                color: isSelectedTrainee ? colorBlueshade : colorShadowGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        children: [
                          GoGymAvatar(
                            imageUrl: trainees[index].imageUrl,
                            text: trainees[index].name[0].toUpperCase(),
                          ),
                          isSelectedTrainee
                              ? Positioned(
                                top: 0,
                                left: 40,
                                right: 0,
                                bottom: 60,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      trainees[index].name,
                      style: GoogleFonts.inter(
                        color: colorblack,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 16),
        itemCount: trainees.length,
      ),
    );
  }

  _packageSelection() {
    return selectedTrainee != null
        ? Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Package',
              style: GoogleFonts.inter(
                color: colorBlackShadeFour,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            TraineePackageManagerWidget(
              trainee: selectedTrainee!,
              onPackageSelect: (val) {
                selectedPackage = val;
                widget.onPackageSelect(val);
              },
            ),
            SizedBox(height: 16),
          ],
        )
        : Container();
  }
}
