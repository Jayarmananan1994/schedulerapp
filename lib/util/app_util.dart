import 'package:flutter/material.dart';

bool isSameDate(DateTime? dateOne, DateTime? dateTwo) {
  if (dateOne != null && dateTwo == null) {
    return false;
  }
  if (dateOne == null && dateTwo != null) {
    return false;
  }
  if (dateOne == null && dateTwo == null) {
    return true;
  }
  return dateOne!.year == dateTwo!.year &&
      dateOne.month == dateTwo.month &&
      dateOne.day == dateTwo.day;
}

String generateUniqueId() {
  return UniqueKey().toString();
}
