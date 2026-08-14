import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/learning_hub_model.dart';
import 'package:untitled1/features/blog/presentation/widgets/learning_hub_quick_guides_section.dart';
import 'package:untitled1/widgets/container_style_widget.dart';

class LearningHubTroubleshootingSection extends StatelessWidget {
  final List<LearningTroubleshootingModel> items;

  const LearningHubTroubleshootingSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tileColor =
        isDark ? theme.colorScheme.tertiaryContainer : AppColors.lightGrey;

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LearningHubSectionHeader(
            icon: Icons.build_outlined,
            iconBackground: isDark
                ? theme.colorScheme.tertiaryContainer
                : AppColors.lightGrey,
            iconColor: isDark ? AppColors.blue : AppColors.primaryColor,
            title: 'learning_troubleshooting_title'.tr(),
          ),
          SizedBox(height: 14.h),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  item.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
