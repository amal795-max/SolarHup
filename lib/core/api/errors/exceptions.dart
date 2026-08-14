import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../constants/failure_success_message.dart';
import 'failures.dart';

class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

String getErrorMessage(int statusCode, {String? message}) {
  switch (statusCode) {
    case 400:
    case 401:
      return message??'error_invalid_credentials';
    case 403:
      return 'error_access_denied';
    case 404:
      return 'error_not_found';
    case 408:
      return 'error_timeout';
    case 422:
      return 'error_invalid_input';
    case 429:
      return 'error_too_many_requests';
    case 500:
      return 'error_server';
    case 502:
      return 'error_bad_gateway';
    case 503:
      return 'error_service_unavailable';
    default:
      return 'error_unexpected';
  }
}


String mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      if (e.error is SocketException) {
        return 'connection_refused';
      }
      return 'network_error';

    case DioExceptionType.connectionTimeout:
      return 'connection_timeout';

    case DioExceptionType.sendTimeout:
      return 'send_timeout';

    case DioExceptionType.receiveTimeout:
      return 'receive_timeout';

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode ?? 0;
      return getErrorMessage(statusCode);

    case DioExceptionType.cancel:
      return 'request_cancelled';

    case DioExceptionType.unknown:
    default:
      return 'unexpected_network_error';
  }
}

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case const (OfflineFailure):
      return OFFLINE_FAILURE_MESSAGE;
    case const (ServerFailure):
      return (failure as ServerFailure).message;
    case const (CacheFailure):
      return EMPTY_CACHE_FAILURE_MESSAGE;
    default:
      return 'error_unexpected'.tr();
  }
}
