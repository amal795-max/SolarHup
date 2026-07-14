import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_cubit.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BlogCategorySection extends StatelessWidget {
  const BlogCategorySection({super.key});

  static const _categoryKeys = [
    'blog_filter_all',
    'panels',
    'inverters',
    'batteries',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<BlogCubit, BlogState>(
      buildWhen: (prev, curr) =>
          curr is BlogLoaded &&
          (prev is! BlogLoaded ||
              prev.selectedCategoryIndex != curr.selectedCategoryIndex),
      builder: (context, state) {
        if (state is! BlogLoaded) return const SizedBox.shrink();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_categoryKeys.length, (index) {
              final isActive = state.selectedCategoryIndex == index;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: SizedBox(
                  height: 36.h,
                  child: CustomButton(
                    text: _categoryKeys[index].tr(),
                    height: 36.h,
                    width: index == 0 ? 64.w : 92.w,
                    fontWeight: FontWeight.w600,
                    backgroundColor: isActive
                        ? AppColors.secondaryColor
                        : (isDark
                            ? theme.colorScheme.surface
                            : AppColors.lightGrey),
                    textColor: isActive
                        ? AppColors.black
                        : theme.textTheme.bodyMedium?.color,
                    onPressed: () =>
                        context.read<BlogCubit>().selectCategory(index),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
