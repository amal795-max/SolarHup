import "package:flutter/material.dart";
import "package:get/get.dart";
import "../core/constants/app_colors.dart";
import "authentication_service.dart";
import "local_storage_services.dart";

class ApplicationService {
  static void showAlertMessage(
      String message, {
        Color? textColor,
        Color? background,
      }) {
    final context = Get.context!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );

  }


  static void showAlertDialog(
      {
      bool barrierDismissible = false,
        void Function()? btnCancelPress,
        required  String title,
        required   String desc,
        required   void Function()? btnOkOnPress,
      }

      ) {

    Get.dialog(
        AlertDialog(
      title: Text(title),
      content:Text(desc),
      actions: [
        TextButton(
          onPressed: () => btnCancelPress?? Get.back(),
          child:  Text("Cancel".tr,style: TextStyle(color: AppColors.mainAppColor),),
        ),
        TextButton(
          onPressed: btnOkOnPress,
          child:  Text("Confirm".tr,style: TextStyle(color: AppColors.mainAppColor),),
        ),
      ],


    )
    );
  }

  static void showSocketExceptionError() {
    Get.snackbar(
      "Connection Error".tr,
      "Sorry no internet, please check your connection, and try again.".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 0,
      margin: const EdgeInsets.all(10),
      borderColor: Colors.red[300],
      borderWidth: 1,
    );
  }

  static void showAlertToastAndLogout(String? error) async {
    if (error != null) {
      Get.snackbar(
        error,
        "",
        backgroundColor: AppColors.lightMain,
        colorText: AppColors.white,
      );
      localStorageServices.logout();
      AuthenticationService.isLogin = false;
      AuthenticationService.currentUser = null;
      //  Get.toNamed<dynamic>(SplashScreen.route);
    }
  }
}
