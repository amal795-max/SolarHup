import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/contiune_with_google.dart';
import '../widgets/header.dart';
import '../widgets/white_section_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: <Widget>[
              headerWidget(
                title: 'solar_hub',
                subTitle: 'empowering_future',
                icon: Icons.password_rounded,
              ),
              whiteSectionWidget(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'join_solarhub'.tr(),
                        style: AppStyle.h5.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        'complete_details'.tr(),
                        style: AppStyle.labelSmall.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      title: 'full_name'.tr(),
                      hint: 'enter_name_hint'.tr(),
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person_2_outlined),
                    ),
                    CustomTextField(
                      title: 'password'.tr(),
                      hint: 'enter_password_hint'.tr(),
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.lock_outline_sharp),
                      isPassword: true,
                    ),
                    CustomTextField(
                      title: 'phone_number'.tr(),
                      hint: '(555) 000-0000',
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.local_phone_outlined),
                    ),
                    SizedBox(height: 8.h),

                    CustomButton(
                      text: 'create_account'.tr(),
                      onPressed: () {
                        context.pushReplacement(AppRoutes.verificationScreen);
                      },
                      textColor: AppColors.white,
                      icon: Icons.arrow_forward_rounded,
                    ),


                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already_have_account'.tr(),
                          style: AppStyle.bodyXSmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushReplacement(AppRoutes.loginScreen);
                          },
                          child: Text(
                            'log_in'.tr(),
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
              continueWithGoogle(),
              const SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}
