import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/gogym_avatar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/service/storage_service.dart';

class TrainerSelectionWidget extends StatefulWidget {
  final Function onSelect;
  const TrainerSelectionWidget({super.key, required this.onSelect});

  @override
  State<TrainerSelectionWidget> createState() => _TrainerSelectionWidgetState();
}

class _TrainerSelectionWidgetState extends State<TrainerSelectionWidget> {
  Trainer? selectedTrainer;
  final StorageService _storageService = GetIt.I<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Trainer',
          style: GoogleFonts.inter(
            color: colorBlackShadeFour,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        FutureBuilder<List<Trainer>>(
          future: _storageService.getTrainerList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No trainers available.'));
            } else {
              final trainers = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [_trainerList(trainers), SizedBox(height: 12)],
              );
            }
          },
        ),
      ],
    );
  }

  _trainerList(List<Trainer> trainers) {
    return SizedBox(
      height: 114,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool isSelectedTrainer = selectedTrainer == trainers[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTrainer = trainers[index];
              });
              widget.onSelect(trainers[index]);
            },
            child: Container(
              width: 100,
              height: 120,
              //padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelectedTrainer ? colorBlueshade : colorShadowGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        children: [
                          GoGymAvatar(
                            imageUrl: trainers[index].imageUrl,
                            text: trainers[index].name[0].toUpperCase(),
                          ),
                          isSelectedTrainer
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
                      trainers[index].name,
                      style: GoogleFonts.inter(
                        color: colorblack,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      trainers[index].role,
                      style: GoogleFonts.inter(
                        color: colorgrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 16),
        itemCount: trainers.length,
      ),
    );
  }
}
