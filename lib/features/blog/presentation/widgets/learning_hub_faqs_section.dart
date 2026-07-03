import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/presentation/widgets/learning_hub_quick_guides_section.dart';
import 'package:untitled1/widgets/container_style_widget.dart';
import 'package:untitled1/widgets/text_with_icon.dart';

class LearningHubFaqsSection extends StatelessWidget {
  final List<String> questions;
  final VoidCallback? onViewAllTap;

  const LearningHubFaqsSection({
    super.key,
    required this.questions,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final linkColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LearningHubSectionHeader(
            icon: Icons.help_outline_rounded,
            iconBackground: isDark
                ? theme.colorScheme.tertiaryContainer
                : AppColors.lightGrey,
            iconColor: linkColor,
            title: 'learning_common_faqs_title'.tr(),
          ),
          SizedBox(height: 14.h),
          ...questions.map(
            (question) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                question,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey,
                  fontStyle: FontStyle.italic,
                  height: 1.45,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          TextWithIcon(
            title: 'learning_view_all_faqs'.tr(),
            icon: Icons.arrow_forward_rounded,
            color: linkColor,
            onTap: onViewAllTap,
          ),
        ],
      ),
    );
  }
}
