import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class LearningHubHeaderSection extends StatelessWidget {
  const LearningHubHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'learning_hub_title'.tr(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: headingColor,
            height: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'learning_hub_description'.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.blue : AppColors.deepGrey,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
