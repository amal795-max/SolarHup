import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class AddedToCartBanner {
  AddedToCartBanner._();

  static void show(BuildContext context) {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        content: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.secondaryColor,
              size: 22.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'item_added_to_cart'.tr(),
                style: AppStyle.labelMedium.copyWith(color: AppColors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                messenger.hideCurrentSnackBar();
                context.push(AppRoutes.cartScreen);
              },
              child: Text(
                'add_to_cart_view_cart'.tr(),
                style: AppStyle.labelMedium.copyWith(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
