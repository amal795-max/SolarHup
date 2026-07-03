import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/package_comparison/data/models/package_comparison_model.dart';

class PackageComparisonProductCardsSection extends StatelessWidget {
  final SolarPackageModel starter;
  final SolarPackageModel premium;

  const PackageComparisonProductCardsSection({
    super.key,
    required this.starter,
    required this.premium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _PackageCard(package: starter)),
        SizedBox(width: 12.w),
        Expanded(child: _PackageCard(package: premium, isHighlighted: true)),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  final SolarPackageModel package;
  final bool isHighlighted;

  const _PackageCard({
    required this.package,
    this.isHighlighted = false,
  });

  String _badgeKey(SolarPackageTier tier) => switch (tier) {
        SolarPackageTier.basic => 'badge_basic',
        SolarPackageTier.premium => 'badge_premium',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final isPremium = package.tier == SolarPackageTier.premium;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isHighlighted
              ? AppColors.secondaryColor
              : theme.colorScheme.outline.withValues(alpha: 0.25),
          width: isHighlighted ? 1.5 : 1,
        ),
        boxShadow: [
          if (!context.brightness)
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.15,
                child: package.imageUrl != null
                    ? Image.network(
                        package.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            ColoredBox(
                          color: Color(package.imageColorValue),
                          child: Icon(
                            Icons.solar_power_outlined,
                            color: AppColors.white.withValues(alpha: 0.7),
                            size: 40.sp,
                          ),
                        ),
                      )
                    : ColoredBox(
                        color: Color(package.imageColorValue),
                        child: Icon(
                          Icons.solar_power_outlined,
                          color: AppColors.white.withValues(alpha: 0.7),
                          size: 40.sp,
                        ),
                      ),
              ),
              if (package.isPopular)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'badge_popular'.tr(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: isPremium
                        ? titleColor
                        : (isDark
                            ? AppColors.darkGray
                            : AppColors.lightGrey),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    _badgeKey(package.tier).tr(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isPremium ? AppColors.white : AppColors.grey,
                      fontWeight: FontWeight.w800,
                      fontSize: 9.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  package.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
