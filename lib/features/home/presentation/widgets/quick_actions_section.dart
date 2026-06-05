import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onCalculatorTap;
  final VoidCallback? onCompareTap;

  const QuickActionsSection({
    super.key,
    this.onCalculatorTap,
    this.onCompareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              iconBgColor: AppColors.secondaryColor,
              iconColor: AppColors.brown,
              icon: Icons.calculate_outlined,
              title: 'home_calculator'.tr(),
              subtitle: 'home_roi_savings'.tr(),
              onTap: onCalculatorTap,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _QuickActionCard(
              iconBgColor: AppColors.lightMain.withValues(alpha: 0.15),
              iconColor: AppColors.lightMain,
              icon: Icons.compare_arrows_rounded,
              title: 'home_compare'.tr(),
              subtitle: 'home_compare_desc'.tr(),
              onTap: onCompareTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkContainer : AppColors.backGroundGrey,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark ? AppColors.darkGray : AppColors.borderColor,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: AppStyle.bodySmall.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: AppStyle.labelXSmall.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
