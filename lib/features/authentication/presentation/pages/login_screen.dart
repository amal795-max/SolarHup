import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/authentication/presentation/widgets/confirmation_widget.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';

import '../../../../core/constants/app_images.dart';
import '../widgets/contiune_with_google.dart';
import '../widgets/white_section_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imageWidget(),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                whiteSectionWidget(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          title: 'phone_number'.tr(),
                          hint: '+1 (555) 000-0000',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icon(Icons.phone_outlined, size: 20.sp, color: AppColors.grey),
                        ),
                        CustomTextField(
                          title: 'password'.tr(),
                          hint: 'enter_password_hint'.tr(),
                          isPassword: true,
                          prefixIcon: Icon(Icons.lock_outline, size: 20.sp,
                              color: AppColors.grey),
                        ),
                        InkWell(
                          onTap: () {
                            context.push(AppRoutes.resetPasswordScreen);
                          }, child: Text('forget_password'.tr(), style: AppStyle
                            .labelXSmall),),
                        SizedBox(height: 12.h),
                        CustomButton(text: 'login'.tr(), onPressed: () {},),

                        continueWithGoogle(),

                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'dont_have_account'.tr(),
                              style: AppStyle.bodyXSmall.copyWith(
                                  color: AppColors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pushReplacement(AppRoutes.registerScreen);
                              },
                              child: Text(
                                'create_account'.tr(),
                                style: AppStyle.bodyXSmall.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),
                  confirmationWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack _imageWidget() {
    return Stack(
      children: [
        Container(
          height: 0.28.sh,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),

            image: const DecorationImage(
              image: AssetImage(AppImages.solrPanelsIcon), fit: BoxFit.cover,),
          ),
        ),
        Container(
          height: 0.28.sh,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black12,
                Colors.black87,
              ],
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'welcome_back'.tr(),
                style: AppStyle.h3.copyWith(color: Colors.white),
              ),
              SizedBox(height: 8.h),
              Text(
                'sign_in_subtitle'.tr(),
                style: AppStyle.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );

  }
}
