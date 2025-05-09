class ResourceCreationException extends Error {
  final String message;
  ResourceCreationException(this.message);

  @override
  String toString() {
    return message;
  }
}
