import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/faq_hub_model.dart';
import 'package:untitled1/features/blog/presentation/bloc/faq_hub_bloc/faq_hub_bloc.dart';

class FaqCategorySection extends StatelessWidget {
  final List<FaqCategoryModel> categories;

  const FaqCategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<FaqHubBloc, FaqHubState>(
      buildWhen: (prev, curr) =>
          curr is FaqHubLoaded &&
          (prev is! FaqHubLoaded ||
              prev.selectedCategoryIndex != curr.selectedCategoryIndex),
      builder: (context, state) {
        if (state is! FaqHubLoaded) return const SizedBox.shrink();

        final chipCount = categories.length + 1;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(chipCount, (index) {
              final isActive = state.selectedCategoryIndex == index;
              final label = index == 0
                  ? 'faq_filter_all_topics'.tr()
                  : categories[index - 1].label;

              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Material(
                  color: isActive
                      ? AppColors.secondaryColor
                      : (isDark
                          ? theme.colorScheme.surface
                          : AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(10.r),
                  child: InkWell(
                    onTap: () => context
                        .read<FaqHubBloc>()
                        .add(SelectFaqCategoryEvent(index)),
                    borderRadius: BorderRadius.circular(10.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.black
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
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
