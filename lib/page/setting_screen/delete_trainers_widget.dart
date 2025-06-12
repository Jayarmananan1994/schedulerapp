import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class DeleteTrainerWidget extends StatelessWidget {
  final StorageService _storageService = GetIt.I<StorageService>();
  DeleteTrainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _deleteTrainers(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: colorGrayBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clear Trainer List',
              style: GoogleFonts.inter(fontSize: 17, color: colorblack),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: colorgrey),
          ],
        ),
      ),
    );
  }

  _deleteTrainers(context) {
    showAppConfirmationDialog(
      context,
      "Confirmation",
      "Are you sure you want to delete trainer list",
    ).then((val) async {
      await _storageService.deleteAllStaff();
      showAppInfoDialog(
        context,
        'Done',
        'All Trainers data cleared',
        'Ok',
        false,
      );
    });
  }
}
