import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';
import 'package:untitled1/widgets/container_style_widget.dart';
import 'package:untitled1/widgets/text_with_icon.dart';

class BlogArticleCard extends StatelessWidget {
  final BlogArticleModel article;
  final VoidCallback? onTap;

  const BlogArticleCard({
    super.key,
    required this.article,
    this.onTap,
  });

  IconData _iconForType(String type) => switch (type) {
        'battery' => Icons.battery_charging_full_outlined,
        'inverter' => Icons.bolt_rounded,
        _ => Icons.description_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      elevation: isDark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 132.h,
              width: double.infinity,
              color: Color(article.imagePlaceholderColorValue),
              child: article.iconType == 'document'
                  ? null
                  : Center(
                      child: Icon(
                        _iconForType(article.iconType),
                        size: 42.sp,
                        color: AppColors.grey.withValues(alpha: 0.55),
                      ),
                    ),
            ),
            container(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWithIcon(
                    title: article.dateLabel,
                    icon: Icons.calendar_today_outlined,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    article.excerpt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? theme.colorScheme.tertiaryContainer
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          article.categoryLabel,
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                      const Spacer(),
                      TextWithIcon(
                        title: 'blog_read_more'.tr(),
                        icon: Icons.arrow_forward_rounded,
                        color: theme.colorScheme.onSurface,
                        onTap: onTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
