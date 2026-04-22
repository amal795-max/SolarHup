import "dart:io";

import "package:dio/dio.dart";

import "../../core/constants/app_url.dart";
import "../../core/util/network/interceptor.dart";
import "../../services/application_services.dart";

class ApiProvider {
  static late Dio dio;

  ApiProvider.initialize() {
    dio = _getDioInstanceWithOptions();
  }

  Dio _getDioInstanceWithOptions() {
    Dio dioInstance = Dio();
    dioInstance.options.baseUrl = UrlPath.baseUrl;
    dioInstance.interceptors.add(CustomInterceptors(dioInstance));
    return dioInstance;
  }

  static Future<dynamic> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? extra,
      }) async {
    try {
      Uri uri = Uri.parse(url);
      Uri newUri = uri.replace(queryParameters: queryParameters);
      print(uri);
      Response<dynamic> response = await dio.getUri(
        newUri,
        options: Options(headers: headers, extra: extra),
      );
      return response;
    } on SocketException catch (_) {
      ApplicationService.showSocketExceptionError();
    }
  }

  static Future<dynamic> post(
      String url,
      dynamic formData, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      Uri uri = Uri.parse(url);
      Uri newUri = uri.replace(queryParameters: queryParameters);
      Response<dynamic> response = await dio.postUri(
        newUri,
        data: formData,
        options: Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (int? status) {
            return status! <= 500;
          },
        ),
      );
      return response;
    } on SocketException catch (_) {
      ApplicationService.showSocketExceptionError();
    }
  }

  static Future<dynamic> postOrder(
      String url,
      Map<String, dynamic> formData, {
        Map<String, dynamic>? headers,
      }) async {
    try {
      Response<dynamic> response = await dio.postUri(
        Uri.parse(url),
        data: formData,
        options: Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (int? status) {
            return status! <= 500;
          },
        ),
      );
      return response;
    } on SocketException catch (_) {
      ApplicationService.showSocketExceptionError();
    }
  }

  static Future<dynamic> put(
      String url,
      Map<String, dynamic> formData, {
        Map<String, dynamic>? headers,
      }) async {
    formData["_method"] = "PUT";
    try {
      Response<dynamic> response = await dio.postUri(
        Uri.parse(url),
        data: FormData.fromMap(formData),
        options: Options(
          headers: headers,
          validateStatus: (int? status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } on SocketException catch (_) {
      ApplicationService.showSocketExceptionError();
    }
  }

  static Future<dynamic> delete(
      String url, {
        Map<String, String>? data,
        Map<String, String>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      Uri uri = Uri.parse(url);
      Uri newUri = uri.replace(queryParameters: queryParameters);
      Response<dynamic> response = await dio.deleteUri(
        newUri,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on SocketException catch (_) {
      ApplicationService.showSocketExceptionError();
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> download(
      String url,
      String filePath, {
        Map<String, dynamic>? headers,
      }) async {
    try {
      Response<dynamic> response = await dio.downloadUri(
        Uri.parse(url),
        filePath,
        options: Options(headers: headers),
      );
      return response;
    } on SocketException catch (_) {
      ApplicationService.showSocketExceptionError();
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> patch(
      String url,
      Map<String, dynamic> data, {
        Map<String, dynamic>? headers,
      }) async {
    // data["_method"] = "PATCH";
    try {
      Response<dynamic> response = await dio.patchUri(
        Uri.parse(url),
        data: data,
        options: Options(
          headers: headers,
          validateStatus: (int? status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } on SocketException catch (_) {
      ApplicationService.showSocketExceptionError();
    }
  }

}
