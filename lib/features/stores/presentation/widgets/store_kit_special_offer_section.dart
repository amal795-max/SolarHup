import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/widgets/primary_button.dart';

class StoreKitSpecialOfferSection extends StatelessWidget {
  const StoreKitSpecialOfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'store_kit_special_offers'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF1B3B55), const Color(0xFF0F2233)]
                  : [const Color(0xFF355A78), const Color(0xFF0A2A43)],
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'store_kit_limited_time'.tr(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.tertiaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'store_kit_offer_title'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'store_kit_offer_subtitle'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomButton(
                  text: 'store_kit_shop_bundles'.tr(),
                  backgroundColor: AppColors.white,
                  textColor: AppColors.primaryColor,
                  height: 34.h,
                  width: 112.w,
                  fontWeight: FontWeight.w600,
                  onPressed: () {
                    context.push(
                      AppRoutes.productDetailScreen,
                      extra: 'helios-450w',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
