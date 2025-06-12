import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAppInfoDialog(
  BuildContext context,
  String title,
  String content,
  String okText,
  bool isError,
) {
  return showCupertinoDialog(
    context: context,
    builder:
        (context) => CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(color: isError ? Colors.red : Colors.black),
          ),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(okText),
            ),
          ],
        ),
  );
}

Future<dynamic> showAppConfirmationDialog(context, title, confirmationText) {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(confirmationText),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
