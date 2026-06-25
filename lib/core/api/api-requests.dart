import 'dart:math';

import 'package:dio/dio.dart';
import 'package:untitled1/core/constants/environment_config.dart';

import '../constants/app_url.dart';
import '../helper/local_storage.dart';
import 'api_interceptor.dart';

class ApiRequest {
  final Dio dio;

  ApiRequest({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: EnvironmentConfig.apiEndpoint,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:CustomInterceptors().onRequest,
        onResponse: CustomInterceptors().onResponse,
        onError:CustomInterceptors().onError
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      dio.get(path, queryParameters: query);

  Future<Response> post(String path, {Map<String, dynamic>? body}) =>
      dio.post(path, data: body);

  Future<Response> delete(String path, {Map<String, dynamic>? body}) =>
      dio.delete(path, data: body);

  Future<Response> put(String path, {Map<String, dynamic>? body}) =>
      dio.put(path, data: body);
}
