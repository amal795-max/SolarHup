import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onExpertTap;
  final VoidCallback? onUsedSystemsTap;

  const QuickActionsSection({
    super.key,
    this.onExpertTap,
    this.onUsedSystemsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              iconBgColor: AppColors.lightYellow,
              iconColor: AppColors.brown,
              icon: Icons.support_agent,
              title: 'home_expert_call'.tr(),
              subtitle: 'home_expert_call_sub'.tr(),
              onTap: onExpertTap,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _QuickActionCard(
              iconBgColor: AppColors.blue.withValues(alpha: 0.3),
              iconColor: AppColors.primaryColor,
              icon: Icons.recycling_rounded,
              title: 'home_used_systems'.tr(),
              subtitle: 'home_used_systems_desc'.tr(),
              onTap: onUsedSystemsTap,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: context.brightness
                ? AppColors.darkContainer
                : const Color(0xFFE3E2E4),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: context.brightness
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: SizedBox(
            height: 140.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
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
                    color: context.brightness
                        ? AppColors.white
                        : AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: Text(
                    subtitle,maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: AppStyle.labelXSmall.copyWith(color: AppColors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
