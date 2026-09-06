import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

import '../../../../widgets/primary_button.dart';
import '../../../../widgets/success_celebration_icon.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const SuccessCelebrationIcon(
                size: 120,
                iconColor: AppColors.primaryColor,
              ),
              SizedBox(height: 32.h),
              Text(
                'order_placed_successfully'.tr(),
                textAlign: TextAlign.center,
                style: AppStyle.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'order_confirmed_subtitle'.tr(),
                textAlign: TextAlign.center,
                style: AppStyle.bodyMedium.copyWith(color: AppColors.grey),
              ),
              const Spacer(),
              CustomButton(
                text: 'order_tracking'.tr(),
                onPressed: () {
                  context.pushReplacement(AppRoutes.orderTrackingScreen);
                },
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () {
                  context.go(AppRoutes.bottomNavBar);
                },
                child: Text(
                  'back_home'.tr(),
                  style: AppStyle.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
