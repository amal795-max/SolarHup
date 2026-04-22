import "dart:io";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../data/models/error_response.dart";
import "../../../data/models/refresh_token_exception.dart";
import "../../../services/application_services.dart";
import "../../../services/authentication_service.dart";
import "../helper/loader_controller.dart";
import "../routing/paths.dart";
import "../routing/route_controller.dart";

class CustomInterceptors extends Interceptor {
  Dio previous;

  Dio refreshDio = Dio();

  CustomInterceptors(this.previous);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var fullScreenLoader = options.extra["fullScreenLoader"] ?? true;
   loaderController.startLoading(fullScreen: fullScreenLoader);
    bool? needAuth = await options.headers["need_auth"];
    if (needAuth ?? false) {
      try {
        String? accessToken;
        accessToken = await AuthenticationService.getToken();
        print("accessToken");
        print(accessToken);
        options.headers["Authorization"] = "Bearer $accessToken";
      } on RefreshTokenException catch (_) {
       loaderController.stopLoading(fullScreen: fullScreenLoader);
        handler.reject(
          RefreshDioTokenError("Your session expired".tr, options),
        );
        ApplicationService.showAlertMessage("Your session expired".tr);
        return;
      }
    }
    options.headers["Accept"] = "application/vnd.api.v1+json";
    options.headers["Content-Type"] = "application/json";
    options.headers["Platform"] = Platform.isIOS ? "ios" : "android";
    // options.headers["language"] = Get.locale!.languageCode;

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    loaderController.stopLoading();
    final BuildContext? context = Get.context;
    if (err.error is SocketException) {
     routeController.popAllAndGoNamed(Paths.noInternetScreen);
    } else if (err.response!.statusCode == 401) {
      ApplicationService.showAlertMessage("Your session expired".tr);
      super.onError(err, handler);
    } else if (err.response!.statusCode == 403) {
      String message = err.response!.data["message"];

      final SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);

      super.onError(err, handler);
    } else if (err.response!.statusCode == 422) {
      String msg = ErrorResponse.fromJson(err.response!.data["data"]).value;
      final SnackBar snackBar = SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);

      super.onError(err, handler);
    } else if (err.response!.statusCode! >= 500) {
      const SnackBar snackBar = SnackBar(
        content: Text("Server error: Please wait and try again."),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
      super.onError(err, handler);
    }
  }

  @override
  void onResponse(var response, ResponseInterceptorHandler handler) {
    loaderController.stopLoading();
    final BuildContext? context = Get.context;
    if (response.statusCode == 401) {
      ApplicationService.showAlertMessage("Your session expired".tr);
    } else if (response.statusCode == 403) {
      String message = response.data["message"];

      final SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    } else if (response.statusCode == 422) {
      if (response.data["data"] == "") {
        String msg = ErrorResponse.fromJson(response.data).value;
        final SnackBar snackBar = SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context!).showSnackBar(snackBar);
      } else {
        String msg = ErrorResponse.fromJson(response.data["data"]).value;
        final SnackBar snackBar = SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context!).showSnackBar(snackBar);
      }
    }
    super.onResponse(response, handler);
  }
}

class RefreshDioTokenError extends DioException {
  String cause;

  RefreshDioTokenError(this.cause, RequestOptions requestOptions)
    : super(requestOptions: requestOptions);

  @override
  String get message => cause;
}
