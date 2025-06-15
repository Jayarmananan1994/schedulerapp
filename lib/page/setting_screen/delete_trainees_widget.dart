import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class DeleteTraineesWidget extends StatelessWidget {
  final StorageService _storageService = GetIt.I<StorageService>();
  DeleteTraineesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _deleteTrainees(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          border: Border.all(color: colorGrayBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clear Trainee List',
              style: GoogleFonts.inter(fontSize: 17, color: colorblack),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: colorgrey),
          ],
        ),
      ),
    );
  }

  _deleteTrainees(context) {
    showAppConfirmationDialog(
      context,
      "Confirmation",
      "Are you sure you want to delete trainee list and thier package ",
    ).then((val) async {
      if (val) {
        int done = await _storageService.deleteAllTrainee();
        showAppInfoDialog(
          context,
          'Done',
          'All Trainees data cleared: $done',
          'Ok',
          false,
        );
      }
    });
  }
}
