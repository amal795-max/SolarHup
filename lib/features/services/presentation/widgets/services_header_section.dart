import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class ServicesHeaderSection extends StatelessWidget {
  const ServicesHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services_professional_care'.tr(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'expert_services_title'.tr(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: titleColor,
            height: 1.15,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'expert_services_description'.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.grey,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
