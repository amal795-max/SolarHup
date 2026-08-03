import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/services/data/models/expert_service_model.dart';
import 'package:untitled1/widgets/primary_button.dart';

class FeaturedServiceCard extends StatelessWidget {
  final ExpertServiceModel service;
  final VoidCallback? onQuoteTap;

  const FeaturedServiceCard({
    super.key,
    required this.service,
    this.onQuoteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final bgColor =
        isDark ? AppColors.deepPrimaryColor : AppColors.primaryColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8.w,
              bottom: -12.h,
              child: Icon(
                Icons.solar_power_rounded,
                size: 120.sp,
                color: AppColors.white.withValues(alpha: 0.06),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'services_best_value_badge'.tr(),
                    style: AppStyle.labelSmall.copyWith(
                      color: AppColors.tertiaryColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  service.title,
                  style: AppStyle.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                if (service.description != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    service.description!,
                    style: AppStyle.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.75),
                      height: 1.45,
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'services_starting_at'.tr(),
                            style: AppStyle.labelSmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            '\$${service.price.toStringAsFixed(0)}',
                            style: AppStyle.h5.copyWith(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 120.w,
                      height: 40.h,
                      child: CustomButton(
                        text: 'services_get_quote'.tr(),
                        height: 40.h,
                        backgroundColor: AppColors.secondaryColor,
                        textColor: AppColors.primaryColor,
                        onPressed: onQuoteTap ??
                            () => context.push(
                                  AppRoutes.scheduleService(service.id),
                                ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
