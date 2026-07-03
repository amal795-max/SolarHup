import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/widgets/container_style_widget.dart';

class StepInstructionCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final bool isActive;

  const StepInstructionCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final indexBg = isActive
        ? AppColors.secondaryColor
        : (context.brightness
            ? AppColors.darkGray
            : AppColors.lightGrey.withValues(alpha: 0.9));
    final indexColor =
        isActive ? AppColors.primaryColor : AppColors.grey;

    return container(
      context: context,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: indexBg,
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNumber',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: indexColor,
              ),
            ),
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
                    color: titleColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.grey,
                    height: 1.45,
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
