import 'package:dio/dio.dart';
import 'package:untitled1/core/constants/environment_config.dart';

import '../constants/app_url.dart';
import '../helper/local_storage.dart';

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
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final token = LocalStorage().getData(key: ApiKeys.token);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
              return handler.next(response);
            },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          final statusCode = error.response?.statusCode;
          print('''
          [onError] ${error.requestOptions.hashCode} / time: ${DateTime.now().toIso8601String()}
          \tStatus: $statusCode
          ''');
          return handler.resolve(error.response!);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await dio.get(path, queryParameters: query,);
  }

  Future<Response> post(String path, {Map<String, dynamic>? body}) async {
    return await dio.post(path, data: body);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? body}) async {
    return await dio.delete(path, data: body);
  }

  Future<Response> put(String path, {Map<String, dynamic>? body}) async {
    return await dio.put(path, data: body);
  }
}
