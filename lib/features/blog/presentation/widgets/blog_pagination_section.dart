import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_bloc/blog_bloc.dart';

class BlogPaginationSection extends StatelessWidget {
  const BlogPaginationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final buttonColor =
        isDark ? theme.colorScheme.surface : AppColors.lightGrey;

    return BlocBuilder<BlogBloc, BlogState>(
      buildWhen: (prev, curr) =>
          curr is BlogLoaded &&
          (prev is! BlogLoaded || prev.currentPage != curr.currentPage),
      builder: (context, state) {
        if (state is! BlogLoaded) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PageCircleButton(
              color: buttonColor,
              icon: Icons.chevron_left_rounded,
              enabled: state.canGoPrevious,
              onTap: () =>
                  context.read<BlogBloc>().add(const BlogPreviousPageEvent()),
            ),
            SizedBox(width: 16.w),
            Text(
              '${'blog_page'.tr()} ${state.currentPage} ${'blog_of'.tr()} ${state.totalPages}',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(width: 16.w),
            _PageCircleButton(
              color: buttonColor,
              icon: Icons.chevron_right_rounded,
              enabled: state.canGoNext,
              onTap: () =>
                  context.read<BlogBloc>().add(const BlogNextPageEvent()),
            ),
          ],
        );
      },
    );
  }
}

class _PageCircleButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PageCircleButton({
    required this.color,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36.w,
          height: 36.w,
          child: Icon(
            icon,
            size: 22.sp,
            color: enabled
                ? Theme.of(context).colorScheme.onSurface
                : AppColors.grey.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
