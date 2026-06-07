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
        // ── Section title ─────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text('categories'.tr(), style: theme.textTheme.titleMedium),
        ),

        SizedBox(height: 12.h),

        // ── Horizontally scrollable chips ─────────────────────────────────
        BlocBuilder<StoreInfoBloc, StoreInfoState>(
          buildWhen: (prev, curr) =>
              prev.selectedCategoryIndex != curr.selectedCategoryIndex,
          builder: (context, state) {
            return SizedBox(
              height: 84.h,
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
        isDark ? AppColors.lightGray : AppColors.deepGrey;

    return Container(
      width: 76.w,
      // Outer container for shadow — not clipped so shadow shows
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: isSelected || isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : unselectedBg,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : unselectedBorder,
              width: isSelected ? 0 : 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: (isSelected ? AppColors.white : AppColors.primaryColor)
                  .withValues(alpha: 0.18),
              highlightColor: (isSelected
                      ? AppColors.white
                      : AppColors.primaryColor)
                  .withValues(alpha: 0.08),
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
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.white.withValues(alpha: 0.18)
                            : unselectedIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: isSelected ? AppColors.white : unselectedIconColor,
                        size: 18.sp,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    // Label
                    Text(
                      item.label,
                      style: AppStyle.labelXSmall.copyWith(
                        color: isSelected
                            ? AppColors.white
                            : unselectedTextColor,
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
          ),
        ),
      ),
    );
  }
}
