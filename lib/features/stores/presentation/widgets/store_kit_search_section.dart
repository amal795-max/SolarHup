import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_kit_bloc/store_kit_bloc.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/features/stores/presentation/widgets/stores_search_bar.dart';

class StoreKitSearchSection extends StatefulWidget {
  final List<StoreCategoryItem> categories;

  const StoreKitSearchSection({
    super.key,
    required this.categories,
  });

  @override
  State<StoreKitSearchSection> createState() => _StoreKitSearchSectionState();
}

class _StoreKitSearchSectionState extends State<StoreKitSearchSection> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StoresSearchBar(
          controller: _searchController,
          hintText: 'store_kit_search_hint'.tr(),
          onChanged: (value) {
            context.read<StoreKitBloc>().add(
                  UpdateStoreKitSearchQueryEvent(value),
                );
          },
          onClear: () {
            _searchController.clear();
            context.read<StoreKitBloc>().add(
                  const UpdateStoreKitSearchQueryEvent(''),
                );
            setState(() {});
          },
        ),
        SizedBox(height: 12.h),
        BlocBuilder<StoreKitBloc, StoreKitState>(
          builder: (context, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _KitCategoryChip(
                    label: 'all_items'.tr(),
                    isActive: state.selectedCategoryIndex == 0,
                    onTap: () => context.read<StoreKitBloc>().add(
                          const SelectStoreKitCategoryEvent(0),
                        ),
                  ),
                  for (var index = 0; index < widget.categories.length; index++) ...[
                    SizedBox(width: 8.w),
                    _KitCategoryChip(
                      label: widget.categories[index].label,
                      isActive: state.selectedCategoryIndex == index + 1,
                      onTap: () => context.read<StoreKitBloc>().add(
                            SelectStoreKitCategoryEvent(index + 1),
                          ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _KitCategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _KitCategoryChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        isDark ? AppColors.secondaryColor.withValues(alpha: 0.65) : AppColors.brown;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: Material(
        color: isActive
            ? activeColor
            : Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .withValues(alpha: 0.7),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isActive
                        ? AppColors.white
                        : Theme.of(context).textTheme.labelMedium?.color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
