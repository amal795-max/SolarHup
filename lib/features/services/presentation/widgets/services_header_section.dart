import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

import '../../../../core/theme/app_style.dart';

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
            color: AppColors.tertiaryColor,

          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'expert_services_title'.tr(),
          style: AppStyle.h3.copyWith(
            height: 1.2,
          ),

        ),
        SizedBox(height: 8.h),
        Text(
          'expert_services_description'.tr(),
          style: AppStyle.bodySmall.copyWith(
            color: AppColors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
