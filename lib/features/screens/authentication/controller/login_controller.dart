import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/routing/paths.dart';
import '../../../../core/util/routing/route_controller.dart';
import '../../../../data/models/request_model/sign_in_request_model.dart';
import '../../../../services/application_services.dart';
import '../../../../services/authentication_service.dart';
import '../../home_page/custom_bottom_navbar.dart';

class LoginController extends GetxController {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  bool isLoading = false;


  Future<DeviceInfo> _getDeviceInfo() async {
    return DeviceInfo(
      token: "fcm-token-or-apns-token-here",
      udid: 'string',
      platform: Platform.isAndroid?"android":'ios',
      deviceModel: 'iPhone13,4',
    );
  }


  void loginWithEmail() async {
    if (loginKey.currentState!.validate()) {
      isLoading = true;
     // loaderController.startLoading(fullScreen: true);
      update();
      try {
        final logInRequestModel = LogInRequestModel(
            email: email.text,
            password: password.text,
            device: await _getDeviceInfo(),
            roleType: "driver"
        );

        bool response = await AuthenticationService.logInWithEmail(logInRequestModel);

        if (response) {
          Get.off(CustomNavBar());
          await routeController.goNamedAndRemoveUntil(Paths.bottomNavbarScreens);
        } else {

          ApplicationService.showAlertMessage(
            'Invalid email or password',
            background: AppColors.red,
          );

        }
      } catch (e) {
        ApplicationService.showAlertMessage(
          'Login failed. Please try again.',
          background: AppColors.red,
        );

      } finally {
        isLoading = false;
      //  loaderController.stopLoading(fullScreen: true);
        update();
      }

    }
  }
}