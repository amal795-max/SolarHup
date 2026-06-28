abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class OfflineFailure extends Failure {
  const OfflineFailure() : super('No internet connection');
}

class CacheFailure extends Failure {
  const CacheFailure() : super('Cache error');
}
