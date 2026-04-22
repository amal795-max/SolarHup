import 'package:driver_app/core/constants/space_xy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_style.dart';
import '../../../core/constants/asset_path.dart';
import '../../../core/util/helper/validators.dart';
import '../../widgets/animation.dart';
import '../../widgets/fields_widgets/main_text_field.dart';
import '../../widgets/primary_button.dart';
import 'controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: WashingAnimation(
        child: Stack(
          children: [
            if (!isKeyboardOpen)
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(ImagesPaths.bottomImage, fit: BoxFit.cover),
              ),
            SingleChildScrollView(
              child: Column(
                children: [
                  70.0.spaceY,
                  SvgPicture.asset(
                    ImagesPaths.loginLogo,
                    height: 35.h,
                    width: 155.w,
                  ),
                  36.0.spaceY,
                  _header(),
                  16.0.spaceY,
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: GetBuilder<LoginController>(
                      init: LoginController(),
                      builder: (controller) {
                        return Form(
                          key:controller.loginKey ,
                          child: Column(
                            spacing: 16.h,
                            children: [
                              CustomMainTextField(
                                controller: controller.email,
                                keyboardType: TextInputType.emailAddress,
                                withTitle: true,
                                title: "Email".tr,
                                // showNumberPrefix: true,
                                validator: emailValidator,
                                hintText: "Email".tr,
                                icon: ImagesPaths.emailIcon,
                              ),
                              CustomMainTextField(
                                controller: controller.password,
                                passwordVisible: true,
                                isPasswordField: true,
                                withTitle: true,
                                title: "Password".tr,
                                validator: passwordValidator,
                                hintText: "Password".tr,
                                icon: ImagesPaths.passwordIcon,
                              ),
                              1.0.spaceY,

                              PrimaryButton(
                                title: 'Log in'.tr,
                                width: double.infinity,
                                height: 48.h,
                                onTap: () {
                                  controller.loginWithEmail();
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        spacing: 14.h,
        children: [
          Text(
            'Welcome to Swish Driver!'.tr,
            style: AppStyle.h3,
            textAlign: TextAlign.center,
          ),
          Text(
            'Enter your email and password to continue'.tr,
            style: AppStyle.bodyMedium.copyWith(color: AppColors.deepBlue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
