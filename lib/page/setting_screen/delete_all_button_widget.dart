import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class DeleteAllButtonWidget extends StatelessWidget {
  const DeleteAllButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _deleteAllDataConfirmation(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: colorRed),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.warning, size: 20, color: colorRed),
            SizedBox(width: 8),
            Text(
              'Clear All Data',
              style: GoogleFonts.inter(fontSize: 17, color: colorRed),
            ),
            Expanded(child: SizedBox()),
            Icon(Icons.arrow_forward_ios, size: 16, color: colorgrey),
          ],
        ),
      ),
    );
  }

  _deleteAllDataConfirmation(context) {
    showAppConfirmationDialog(
      context,
      "Confirm Action",
      "Are you sure you want to proceed with this action?",
    ).then((val) {
      print(val);
    });
    // showCupertinoModalPopup<void>(
    //   context: context,
    //   builder:
    //       (BuildContext context) => CupertinoAlertDialog(
    //         title: const Text('Confirm Action'),
    //         content: const Text(
    //           'Are you sure you want to proceed with this action?',
    //         ),
    //         actions: <CupertinoDialogAction>[
    //           CupertinoDialogAction(
    //             isDefaultAction: true,
    //             onPressed: () {
    //               Navigator.pop(context);
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 const SnackBar(content: Text('Action confirmed!')),
    //               );
    //             },
    //             child: const Text('Confirm'),
    //           ),
    //           CupertinoDialogAction(
    //             isDestructiveAction: true,
    //             onPressed: () {
    //               Navigator.pop(context);
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 const SnackBar(content: Text('Action cancelled!')),
    //               );
    //             },
    //             child: const Text('Cancel'),
    //           ),
    //         ],
    //       ),
    // );
  }
}
