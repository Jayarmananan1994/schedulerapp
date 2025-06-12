import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class DeleteScheduleWidget extends StatelessWidget {
  final StorageService _storageService = GetIt.I<StorageService>();
  DeleteScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _deleteSchedules(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: Border.all(color: colorGrayBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clear Schedules',
              style: GoogleFonts.inter(fontSize: 17, color: colorblack),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: colorgrey),
          ],
        ),
      ),
    );
  }

  _deleteSchedules(context) {
    showAppConfirmationDialog(
      context,
      "Confirmation",
      "Are you sure you want to delete schedule list",
    ).then((val) async {
      print(val);
      await _storageService.deleteAllSchedules();
      showAppInfoDialog(
        context,
        'Done',
        'All Schedule data cleared',
        'Ok',
        false,
      );
    });
  }
}
