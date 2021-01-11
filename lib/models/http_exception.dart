class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  String tostring() {
    return message;
  }
}
