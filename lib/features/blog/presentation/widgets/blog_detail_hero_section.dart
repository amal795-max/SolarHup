import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_article_image.dart';
import 'package:untitled1/widgets/back_button_widget.dart';

class BlogDetailHeroSection extends StatelessWidget {
  final BlogArticleDetailModel article;

  const BlogDetailHeroSection({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 220.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BlogArticleImage(
            imageUrl: article.imageUrl,
            placeholderColorValue: article.heroColorValue,
            placeholderIcon: Icons.article_outlined,
            overlays: [
              if (article.imageUrl == null || article.imageUrl!.isEmpty)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(article.heroColorValue),
                        AppColors.primaryColor,
                      ],
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topLeft,
              child: BackButtonWidget(),
            ),
          ),
          Positioned(
            left: 16.w,
            bottom: 14.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                article.categoryBadge,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.tertiaryColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
