class PsTokenException implements Exception {
  final String message;

  PsTokenException(this.message);

  @override
  String toString() {
    return 'PsTokenException: $message';
  }

  String getMessage() {
    return message;
  }
}
