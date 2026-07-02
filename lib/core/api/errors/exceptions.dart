import '../../constants/failure_success_message.dart';
import 'failures.dart';

class ServerException implements Exception{
  final String message;

  ServerException({required this.message});

}
class EmptyCacheException implements Exception{}
class OfflineException implements Exception{}

String getErrorMessage(int statusCode) {
  switch (statusCode) {
    case 400:
    case 401:
      return 'Invalid credentials. Please try again.';
    case 403:
      return 'Access denied. You do not have permission.';
    case 404:
      return 'Resource not found! Please check and try again.';
    case 408:
      return 'Request timeout! Please check your internet connection.';
    case 422:
      return 'Invalid input data. Please check the format of the email and password.';
    case 429:
      return 'Too many requests. Please wait a moment and try again.';
    case 500:
      return 'Server errors! Please try again later.';
    case 502:
      return 'Bad gateway. The server received an invalid response.';
    case 503:
      return 'Service unavailable. Please try again shortly.';
    default:
      return 'An unexpected errors occurred. Please try again.';
  }

}
String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case  const (OfflineFailure):
      return OFFLINE_FAILURE_MESSAGE;
    case const (ServerFailure):
      return (failure as ServerFailure).message;
    case const (CacheFailure):
      return EMPTY_CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected errors. Please try again later.';
  }
}