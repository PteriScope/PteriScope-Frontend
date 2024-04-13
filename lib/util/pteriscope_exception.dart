class PteriscopeException implements Exception {
  final String message;

  PteriscopeException(this.message);

  @override
  String toString() {
    return 'PteriscopeException: $message';
  }

  String getMessage() {
    return message;
  }
}