import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_article_image.dart';

class BlogCardData {
  final String id;
  final String title;
  final String meta;
  final int imagePlaceholderColorValue;
  final String? imageUrl;
  final IconData imageIcon;

  const BlogCardData({
    required this.id,
    required this.title,
    required this.meta,
    required this.imagePlaceholderColorValue,
    this.imageUrl,
    this.imageIcon = Icons.article_outlined,
  });
}

class BlogCard extends StatelessWidget {
  final BlogCardData data;
  final VoidCallback? onTap;

  const BlogCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: BlogArticleImage(
                  height: 76.w,
                  width: 76.w,
                  imageUrl: data.imageUrl,
                  placeholderColorValue: data.imagePlaceholderColorValue,
                  placeholderIcon: data.imageIcon,
                  overlays: [
                    if (data.imageUrl == null || data.imageUrl!.isEmpty)
                      ColoredBox(
                        color: Colors.black.withValues(alpha: 0.12),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: AppStyle.bodySmall.copyWith(
                        color: isDark ? AppColors.white : AppColors.black,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      data.meta,
                      style: AppStyle.labelXSmall.copyWith(
                        color: AppColors.grey,
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
