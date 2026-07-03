import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';

class BlogDetailAuthorSection extends StatelessWidget {
  final BlogAuthorModel author;

  const BlogDetailAuthorSection({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
            border: Border.all(
              color: AppColors.secondaryColor.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.bolt_rounded,
            color: AppColors.secondaryColor,
            size: 22.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${author.role} • ${author.dateLabel}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
