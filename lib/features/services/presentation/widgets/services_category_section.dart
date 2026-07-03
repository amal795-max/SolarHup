import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/services_bloc/services_bloc.dart';

class ServicesCategorySection extends StatelessWidget {
  const ServicesCategorySection({super.key});

  static const _categoryKeys = [
    'services_filter_all',
    'services_filter_maintenance',
    'services_filter_installation',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ServicesBloc, ServicesState>(
      buildWhen: (prev, curr) =>
          curr is ServicesLoaded &&
          (prev is! ServicesLoaded ||
              prev.selectedCategoryIndex != curr.selectedCategoryIndex),
      builder: (context, state) {
        if (state is! ServicesLoaded) return const SizedBox.shrink();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_categoryKeys.length, (index) {
              final isActive = state.selectedCategoryIndex == index;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Material(
                  color: isActive
                      ? AppColors.secondaryColor
                      : (isDark
                          ? theme.colorScheme.surface
                          : AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(20.r),
                  child: InkWell(
                    onTap: () => context
                        .read<ServicesBloc>()
                        .add(SelectServicesCategoryEvent(index)),
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        _categoryKeys[index].tr(),
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
