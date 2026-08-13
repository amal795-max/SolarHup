import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';

class ServiceCategoryGrid extends StatelessWidget {
  final List<StoreCategoryModel> categories;
  final ValueChanged<StoreCategoryModel> onCategoryTap;

  const ServiceCategoryGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.98,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        return _ServiceCategoryCard(
          category: category,
          onTap: () => onCategoryTap(category),
        );
      },
    );
  }
}

class _ServiceCategoryCard extends StatelessWidget {
  final StoreCategoryModel category;
  final VoidCallback onTap;

  const _ServiceCategoryCard({
    required this.category,
    required this.onTap,
  });

  IconData _iconForName(String name) {
    final normalized = name.toLowerCase();

    if (normalized.contains('install')) {
      return Icons.solar_power_outlined;
    }

    if (normalized.contains('maint')) {
      return Icons.handyman_outlined;
    }

    if (normalized.contains('batter')) {
      return Icons.battery_charging_full_outlined;
    }

    if (normalized.contains('invert') ||
        normalized.contains('repair')) {
      return Icons.electrical_services_outlined;
    }

    if (normalized.contains('audit') ||
        normalized.contains('energy')) {
      return Icons.analytics_outlined;
    }

    if (normalized.contains('clean')) {
      return Icons.cleaning_services_outlined;
    }

    if (normalized.contains('wiring') ||
        normalized.contains('electrical')) {
      return Icons.cable_outlined;
    }

    return Icons.build_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        splashColor: AppColors.primaryColor.withValues(alpha: 0.06),
        highlightColor: AppColors.primaryColor.withValues(alpha: 0.03),
        child: Ink(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkContainer
                : AppColors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.055),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.lightYellow,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  _iconForName(category.name),
                  color: AppColors.primaryColor,
                  size: 23.sp,
                ),
              ),

              const Spacer(),

              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              SizedBox(height: 6.h),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'services_browse_workshops'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodyXSmall.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15.sp,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}