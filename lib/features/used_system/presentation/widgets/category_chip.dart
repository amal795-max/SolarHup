import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_style.dart';

import '../../../../core/theme/app_colors.dart';

class CategoryFilterSection extends StatelessWidget {
  const CategoryFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        children: [
          _CategoryChip(label: 'all_items'.tr(), icon: Icons.grid_view, isSelected: true),
          _CategoryChip(label: 'panels'.tr(), icon: Icons.solar_power),
          _CategoryChip(label: 'batteries'.tr(), icon: Icons.battery_charging_full),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const _CategoryChip({
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.tertiaryColor : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        spacing: 8.w,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: isSelected ? AppColors.lightOrange : AppColors.primaryColor,
          ),
          Text(
            label,
            style: AppStyle.bodyXSmall.copyWith(
              color: isSelected ? AppColors.lightOrange : null,
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
