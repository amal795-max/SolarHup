import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/used_system/presentation/bloc/used_system_cubit.dart';

import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryFilterSection extends StatelessWidget {
  const CategoryFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsedSystemCubit>();
    
    final categories = [
      {'label': 'all_items', 'icon': Icons.grid_view, 'value': 'all'},
      {'label': 'panels', 'icon': Icons.solar_power, 'value': 'solar_panel'},
      {'label': 'batteries', 'icon': Icons.battery_charging_full, 'value': 'battery'},
      {'label': 'inverters', 'icon': Icons.sync, 'value': 'inverter'},
    ];

    return SizedBox(
      height: 70.h,
      child: BlocBuilder<UsedSystemCubit, UsedSystemState>(
        builder: (context, state) {
          final selectedCategory = cubit.filterCategory ?? 'all';
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selectedCategory == cat['value'];
              return _CategoryChip(
                label: (cat['label'] as String).tr(),
                icon: cat['icon'] as IconData,
                isSelected: isSelected,
                onTap: () => cubit.setFilterCategory(cat['value'] as String),
              ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.2, end: 0);
            },
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 250.ms,
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tertiaryColor:null,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : context.colorScheme.outline,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? AppColors.lightOrange : AppColors.primaryColor,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppStyle.bodyXSmall.copyWith(
                color: isSelected ? AppColors.lightOrange : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ).animate(target: isSelected ? 1 : 0).scaleXY(end: 1.05, duration: 200.ms),
    );
  }
}
