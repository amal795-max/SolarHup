import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_info_bloc/store_info_bloc.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';

/// Horizontally scrollable row of selectable category chips (icon + label).
/// The active chip is driven by [StoreInfoBloc.selectedCategoryIndex].
class StoreInfoCategoriesSection extends StatelessWidget {
  final List<StoreCategoryItem> categories;

  const StoreInfoCategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (categories.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text('categories'.tr(), style: theme.textTheme.titleMedium),
          ),
          BlocBuilder<StoreInfoBloc, StoreInfoState>(
          buildWhen: (prev, curr) =>
              prev.selectedCategoryIndex != curr.selectedCategoryIndex,
          builder: (context, state) {
            if (categories.isEmpty) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              height: 120.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) => _CategoryChip(
                  item: categories[index],
                  isSelected: state.selectedCategoryIndex == index,
                  onTap: () => context
                      .read<StoreInfoBloc>()
                      .add(SelectStoreCategoryEvent(index)),
                ),
              ),
            );
          },
        ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.5),
              height: 1,
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Individual category chip — animated selected/unselected states
// ---------------------------------------------------------------------------

class _CategoryChip extends StatelessWidget {
  final StoreCategoryItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final unselectedBg =
    isDark ? AppColors.darkContainer : AppColors.white;
    final unselectedBorder =
    isDark ? AppColors.darkGray : AppColors.borderColor;
    final unselectedIconBg =
    AppColors.primaryColor.withValues(alpha: 0.10);
    final unselectedIconColor = AppColors.primaryColor;
    final unselectedTextColor =
    isDark ? AppColors.blue : AppColors.deepGrey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 6.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondaryColor.withValues(alpha: 0.25)
                      : unselectedIconBg,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.secondaryColor, width: 2)
                      : null,
                ),
                child: Icon(
                  item.icon,
                  color: unselectedIconColor,
                  size: 24.sp,
                ),
              ),

              SizedBox(height: 6.h),

              // Label
              Text(
                item.label,
                style: AppStyle.labelXSmall.copyWith(
                  color:unselectedTextColor,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
