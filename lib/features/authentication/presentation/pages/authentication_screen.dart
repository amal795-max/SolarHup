import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/authentication/presentation/widgets/header.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/white_section_widget.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: <Widget>[
              headerWidget(
                icon: Icons.solar_power_rounded,
                title: 'Welcome to SolarHub',
                subTitle: 'Sustainable energy, managed simply.',
              ),

              whiteSectionWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     CustomTextField(
                        title: 'phone_number'.tr(),
                        hint: '(555) 000-0000',
                        keyboardType: TextInputType.phone,
                        prefixIcon:const Icon(Icons.phone)
                      ),
                    SizedBox(height: 8.h),
                    CustomButton(
                      text: 'Continue',
                      onPressed: () {
                        context.push(AppRoutes.registerScreen);
                      },
                      textColor: AppColors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32,),
              Text(
                'Need help accessing your account? Contact',
                style: AppStyle.bodyXSmall.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Support',
                  style: AppStyle.bodyXSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
