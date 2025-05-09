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
