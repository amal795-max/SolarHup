import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/package_comparison/data/models/package_comparison_model.dart';
import 'package:untitled1/widgets/container_style_widget.dart';

class PackageComparisonSpecsSection extends StatelessWidget {
  final SolarPackageModel starter;
  final SolarPackageModel premium;

  const PackageComparisonSpecsSection({
    super.key,
    required this.starter,
    required this.premium,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SpecCard(
                icon: Icons.bolt_rounded,
                iconColor: AppColors.secondaryColor,
                labelKey: 'label_total_output',
                starterValue: starter.totalOutput,
                premiumValue: premium.totalOutput,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _SpecCard(
                icon: Icons.battery_charging_full_rounded,
                iconColor: AppColors.blue,
                labelKey: 'label_storage',
                starterValue: starter.storage,
                premiumValue: premium.storage,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _SpecCard(
                icon: Icons.grid_view_rounded,
                iconColor: AppColors.grey,
                labelKey: 'label_panels',
                starterValue: starter.panelsCount,
                premiumValue: premium.panelsCount,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _SpecCard(
                icon: Icons.verified_user_outlined,
                iconColor: AppColors.brown,
                labelKey: 'label_warranty',
                starterValue: starter.warranty,
                premiumValue: premium.warranty,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SpecCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String labelKey;
  final String starterValue;
  final String premiumValue;

  const _SpecCard({
    required this.icon,
    required this.iconColor,
    required this.labelKey,
    required this.starterValue,
    required this.premiumValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final premiumColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDark ? 0.2 : 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.sp, color: iconColor),
          ),
          SizedBox(height: 10.h),
          Text(
            labelKey.tr(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 9.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  starterValue,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  premiumValue,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: premiumColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
