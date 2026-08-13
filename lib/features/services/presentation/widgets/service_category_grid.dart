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
    return Column(
      children: [
        for (var i = 0; i < categories.length; i++)
          _ServiceCategoryTile(
            category: categories[i],
            index: i,
            onTap: () => onCategoryTap(categories[i]),
          ),
      ],
    );
  }
}

class _ServiceCategoryTile extends StatelessWidget {
  final StoreCategoryModel category;
  final int index;
  final VoidCallback onTap;

  const _ServiceCategoryTile({
    required this.category,
    required this.index,
    required this.onTap,
  });

  IconData _iconForName(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('install')) return Icons.solar_power_rounded;
    if (normalized.contains('maint')) return Icons.build_circle_outlined;
    if (normalized.contains('batter')) {
      return Icons.battery_charging_full_rounded;
    }
    if (normalized.contains('invert') || normalized.contains('repair')) {
      return Icons.electrical_services_rounded;
    }
    if (normalized.contains('audit') || normalized.contains('energy')) {
      return Icons.insights_outlined;
    }
    if (normalized.contains('clean')) return Icons.cleaning_services_outlined;
    if (normalized.contains('wiring') || normalized.contains('electrical')) {
      return Icons.cable_rounded;
    }
    return Icons.handyman_outlined;
  }

  Color _accentColor(int index) {
    const palette = [
      AppColors.primaryColor,
      AppColors.tertiaryColor,
      AppColors.green,
      AppColors.brown,
      AppColors.blue,
    ];
    return palette[index % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _accentColor(index);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkContainer : AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 5.w,
                  height: 72.h,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    _iconForName(category.name),
                    color: AppColors.tertiaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.labelLarge.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'services_browse_workshops'.tr(),
                        style: AppStyle.bodySmall.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkGray
                          : AppColors.backGroundGrey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 18.sp,
                      color: AppColors.primaryColor,
                    ),
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
