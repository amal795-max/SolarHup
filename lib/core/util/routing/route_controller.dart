import "package:flutter/material.dart";
import "package:get/get.dart";

RouteController routeController = RouteController.instance;

class RouteController extends GetxController {
  static RouteController instance = Get.find();

  static RouteController get to => Get.find<RouteController>();
  bool enable = true;

  Future<void>? goNamed(String routeName, {List<dynamic>? arguments}) {
    return Get.toNamed(routeName, arguments: arguments ?? []);
  }

  void back({dynamic result}) {
    Get.back<dynamic>(result: result);
  }

  Future<void>? popAndGoNamed(String routeName, {dynamic arguments}) {
    Get.back<dynamic>();
    return Get.offAndToNamed(routeName, arguments: arguments);
  }

  Future<void>? goNamedAndRemoveUntil(String routeName, {dynamic arguments}) {
    return Get.offNamedUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  void popAllAndGoNamed(String route) {
    Get.offAllNamed<dynamic>(route);
  }

  Future<void>? goReplacementNamed(String routeName, {dynamic arguments}) {
    return Get.offNamed(routeName, arguments: arguments);
  }

  bool canGoBack() =>
      Get.isRegistered<NavigatorState>() && Get.previousRoute.isNotEmpty;

  BuildContext getCurrentContext() => Get.context!;

  void closeKeyboard() {
    if (Get.isRegistered<RouteController>()) {
      FocusScope.of(Get.context!).unfocus();
    }
  }
}
