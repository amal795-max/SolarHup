import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_url.dart';
import '../helper/auth_session.dart';
import '../helper/local_storage.dart';
import '../routing/router_keys.dart';
import '../routing/app_routes.dart';

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('FULL URL => ${options.uri}');
    print('body${options.data}');

    final token = LocalStorage().getData(key: ApiKeys.token);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('body${response.data}');

    if (response.statusCode == 401) {
      _handleUnauthorized();
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('[DioError] ${err.message}');

    if (err.response?.statusCode == 401) {
      _handleUnauthorized();
    }

    handler.next(err);
  }

  void _handleUnauthorized() {
    AuthSession.clear();
    final context = rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.go(AppRoutes.authenticationScreen);
    }
  }
}
