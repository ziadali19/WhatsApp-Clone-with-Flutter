abstract class Failure {
  final String? message;

  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class FirebaseFailure extends Failure {
  FirebaseFailure(super.message);
}
