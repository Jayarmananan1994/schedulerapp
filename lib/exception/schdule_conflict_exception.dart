class ScheduleConflictException extends Error {
  final String message;
  ScheduleConflictException(this.message);

  @override
  String toString() {
    return message;
  }
}
