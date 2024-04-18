class PsException implements Exception {
  final String message;

  PsException(this.message);

  @override
  String toString() {
    return 'PsException: $message';
  }

  String getMessage() {
    return message;
  }
}