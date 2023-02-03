class NetworkException implements Exception {
  final String? message;

  NetworkException(this.message);
}

class FireBaseException implements Exception {
  final String? message;

  FireBaseException(this.message);
}
