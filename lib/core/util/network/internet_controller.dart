
import "package:driver_app/services/application_services.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "../routing/paths.dart";
import "../routing/route_controller.dart";
import "check_internet.dart";

class NoInternetController extends GetxController {
  bool isLoading = false;

  Future<dynamic> tryAgain(BuildContext context) async {
    isLoading = true;
    update();
    bool isConnected = await CheckInternet.checkConnect();
    if (isConnected) {
      routeController.enable = true;
      routeController.goNamedAndRemoveUntil(Paths.splashScreen,
        arguments: <dynamic>[],
      );
    } else {
      ApplicationService.showAlertMessage('Sorry no internet,'
          ' please check your connection, and try again.',
      );

    }
    isLoading = false;
    update();
  }
}
