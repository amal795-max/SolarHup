import 'package:dio/dio.dart';
import 'package:untitled1/core/constants/environment_config.dart';
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
      validateStatus: (status) => true,
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

  Future<Response> post(String path, {dynamic body}) =>
      dio.post(path, data: body);

  Future<Response> delete(String path, {dynamic body}) =>
      dio.delete(path, data: body);

  Future<Response> put(String path, {dynamic body}) =>
      dio.put(path, data: body);

  Future<Response> patch(String path, {dynamic body}) =>
      dio.patch(path, data: body);
}
