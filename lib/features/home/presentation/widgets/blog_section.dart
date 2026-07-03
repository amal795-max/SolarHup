import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'blog_card.dart';

class BlogSection extends StatelessWidget {
  final List<BlogCardData> blogs;
  final void Function(String articleId)? onBlogTap;

  const BlogSection({
    super.key,
    required this.blogs,
    this.onBlogTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'home_blog_insights'.tr(),
            style: AppStyle.h6.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        ...blogs.asMap().entries.map(
          (entry) => BlogCard(
            data: entry.value,
            onTap: onBlogTap != null ? () => onBlogTap!(entry.value.id) : null,
          ),
        ),
      ],
    );
  }
}
