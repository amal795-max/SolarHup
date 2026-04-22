import "package:flutter/material.dart";
import "package:get/get.dart";

import "../routing/route_controller.dart";
import "loader_overlay.dart";

LoaderController loaderController = LoaderController.instance;

class LoaderController extends GetxController {
  static LoaderController instance = Get.find();

  static LoaderController get to => Get.find<LoaderController>();
  var isLoading = false;
  bool stopFull = false;

  void startLoading({bool fullScreen = true}) {
    stopFull = fullScreen;
    isLoading = true;
    update();
    if (fullScreen) {
      showLoader(routeController.getCurrentContext());
    }
  }

  void stopLoading({bool fullScreen = true}) {
    isLoading = false;
    update();
    if (stopFull) {
      Navigator.of(routeController.getCurrentContext()).pop();
    }
  }
}
