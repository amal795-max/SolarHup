import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/learning_hub_model.dart';
import 'package:untitled1/widgets/container_style_widget.dart';

class LearningHubQuickGuidesSection extends StatelessWidget {
  final List<LearningGuideModel> guides;
  final void Function(LearningGuideModel guide)? onGuideTap;

  const LearningHubQuickGuidesSection({
    super.key,
    required this.guides,
    this.onGuideTap,
  });

  IconData _iconForType(String type) => switch (type) {
        'finance' => Icons.account_balance_outlined,
        'panel' => Icons.solar_power_outlined,
        'battery' => Icons.battery_charging_full_outlined,
        _ => Icons.wb_sunny_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.menu_book_rounded,
            iconBackground: AppColors.primaryColor,
            iconColor: AppColors.secondaryColor,
            title: 'learning_quick_guides_title'.tr(),
          ),
          SizedBox(height: 14.h),
          ...guides.map(
            (guide) => _GuideTile(
              icon: _iconForType(guide.iconType),
              title: guide.title,
              description: guide.description,
              isDark: isDark,
              onTap: onGuideTap != null ? () => onGuideTap!(guide) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;
  final VoidCallback? onTap;

  const _GuideTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 22.sp,
                color: isDark ? AppColors.blue : AppColors.primaryColor,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.blue : AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.white : AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

// Export section header for reuse in other learning hub sections
class LearningHubSectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;

  const LearningHubSectionHeader({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionHeader(
      icon: icon,
      iconBackground: iconBackground,
      iconColor: iconColor,
      title: title,
    );
  }
}
