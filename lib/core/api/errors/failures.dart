abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class OfflineFailure extends Failure {
  const OfflineFailure() : super('offline_failure_message');
}

class CacheFailure extends Failure {
  const CacheFailure() : super('Cache error');
}
