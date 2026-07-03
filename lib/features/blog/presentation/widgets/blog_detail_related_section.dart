import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';

class BlogDetailRelatedSection extends StatelessWidget {
  final List<BlogArticleModel> articles;

  const BlogDetailRelatedSection({super.key, required this.articles});

  IconData _iconForType(String type) => switch (type) {
        'battery' => Icons.battery_charging_full_outlined,
        'inverter' => Icons.bolt_rounded,
        _ => Icons.description_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (articles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'blog_related_articles'.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.blue : AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 210.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: articles.length,
            separatorBuilder: (_, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final article = articles[index];
              return _RelatedArticleCard(
                article: article,
                isDark: isDark,
                icon: _iconForType(article.iconType),
                onTap: () => context.push(
                  AppRoutes.blogArticleDetail(article.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RelatedArticleCard extends StatelessWidget {
  final BlogArticleModel article;
  final bool isDark;
  final IconData icon;
  final VoidCallback onTap;

  const _RelatedArticleCard({
    required this.article,
    required this.isDark,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardWidth = 200.w;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14.r),
      clipBehavior: Clip.antiAlias,
      elevation: isDark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 96.h,
                width: cardWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(article.imagePlaceholderColorValue),
                      AppColors.primaryColor,
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        icon,
                        size: 16.sp,
                        color: AppColors.tertiaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      article.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
