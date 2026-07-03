import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/faq_hub_model.dart';

class FaqPopularTopicsSection extends StatelessWidget {
  final List<FaqQuestionModel> topics;
  final void Function(FaqQuestionModel topic)? onTopicTap;

  const FaqPopularTopicsSection({
    super.key,
    required this.topics,
    this.onTopicTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.blue : AppColors.primaryColor;

    if (topics.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up_rounded,
              color: AppColors.secondaryColor,
              size: 22.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'faq_popular_topics'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...topics.map(
          (topic) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _PopularTopicCard(
              question: topic.question,
              accentColor: accentColor,
              onTap: onTopicTap != null ? () => onTopicTap!(topic) : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularTopicCard extends StatelessWidget {
  final String question;
  final Color accentColor;
  final VoidCallback? onTap;

  const _PopularTopicCard({
    required this.question,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      elevation: isDark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4.w,
                color: accentColor,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Text(
                    question,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
