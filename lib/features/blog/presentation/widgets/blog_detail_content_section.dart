import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';
import 'package:untitled1/widgets/text_rich_widget.dart';

class BlogDetailContentSection extends StatelessWidget {
  final List<BlogContentBlockModel> blocks;

  const BlogDetailContentSection({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in blocks) ...[
          _ContentBlock(block: block),
          SizedBox(height: _spacingAfter(block)),
        ],
      ],
    );
  }

  double _spacingAfter(BlogContentBlockModel block) {
    return switch (block.type) {
      BlogContentBlockType.heading => 8.h,
      BlogContentBlockType.proTip => 20.h,
      BlogContentBlockType.bulletList => 8.h,
      _ => 16.h,
    };
  }
}

class _ContentBlock extends StatelessWidget {
  final BlogContentBlockModel block;

  const _ContentBlock({required this.block});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return switch (block.type) {
      BlogContentBlockType.paragraph => Text(
          block.text ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.55,
            color: isDark ? AppColors.blue : AppColors.deepGrey,
          ),
        ),
      BlogContentBlockType.heading => Text(
          block.text ?? '',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.blue : AppColors.primaryColor,
          ),
        ),
      BlogContentBlockType.proTip => _ProTipBox(
          title: block.proTipTitle ?? '',
          body: block.text ?? '',
        ),
      BlogContentBlockType.bulletList => Column(
          children: (block.items ?? [])
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _TipRow(text: item),
                ),
              )
              .toList(),
        ),
    };
  }
}

class _ProTipBox extends StatelessWidget {
  final String title;
  final String body;

  const _ProTipBox({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark
        ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.45)
        : AppColors.lightGrey;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.brown,
            size: 22.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextRichWidget(
                  label: 'blog_pro_tip_label'.tr(),
                  value: ' $title',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  valueStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    color: isDark ? AppColors.blue : AppColors.deepGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final String text;

  const _TipRow({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22.w,
          height: 22.w,
          decoration: const BoxDecoration(
            color: AppColors.secondaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 14.sp,
            color: AppColors.tertiaryColor,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
