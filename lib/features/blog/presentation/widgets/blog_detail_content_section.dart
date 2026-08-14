import 'package:flutter/material.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class BlogDetailContentSection extends StatelessWidget {
  final String content;

  const BlogDetailContentSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Text(
      content,
      style: theme.textTheme.bodyMedium?.copyWith(
        height: 1.55,
        color: isDark ? AppColors.blue : AppColors.deepGrey,
      ),
    );
  }
}
