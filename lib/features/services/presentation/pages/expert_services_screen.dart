import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/services/presentation/bloc/service_categories_cubit/service_categories_cubit.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_picker_route_args.dart';
import 'package:untitled1/features/services/presentation/widgets/service_category_grid.dart';
import 'package:untitled1/features/services/presentation/widgets/services_header_section.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';

import '../../../../widgets/error_widget.dart';

class ExpertServicesScreen extends StatelessWidget {
  const ExpertServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ServiceCategoriesCubit>()..loadCategories(),
      child: const _ExpertServicesView(),
    );
  }
}

class _ExpertServicesView extends StatelessWidget {
  const _ExpertServicesView();

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;

    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : AppColors.backGroundGrey,
      body: SafeArea(
         child:  BlocBuilder<ServiceCategoriesCubit, ServiceCategoriesState>(
            builder: (context, state) {
              if (state is ServiceCategoriesError) {
                return errorWidget(
                  message: state.message,
                  onPressed: () => context.read<ServiceCategoriesCubit>().loadCategories(),
                  hasButton: true,
                );
              }

              final isLoading = state is ServiceCategoriesLoading;
              final fakeCategories = List.generate(
                6,
                    (index) => StoreCategoryModel(
                  id: index,
                  name: 'Loading...',
                  type: 'workshop',
                ),
              );

              final categories = isLoading
                  ? fakeCategories
                  : (state is ServiceCategoriesLoaded ? state.categories : <StoreCategoryModel>[]);

              return _ServicesContent(
                categories: categories,
                onCategoryTap: isLoading ? (_) {}
                    : (category) {
                  context.push(
                    AppRoutes.workshopPickerScreen,
                    extra: WorkshopPickerRouteArgs(
                      categoryId: category.id,
                      categoryName: category.name,
                    ),
                  );
                },
                isLoading: isLoading,
                onRefresh: isLoading
                    ? null
                    : () => context.read<ServiceCategoriesCubit>().loadCategories(),
              );
            },
          )
      ),
    );
  }
}

class _ServicesContent extends StatelessWidget {
  final List<StoreCategoryModel> categories;
  final ValueChanged<StoreCategoryModel> onCategoryTap;
  final bool isLoading;
  final Future<void> Function()? onRefresh;

  const _ServicesContent({
    required this.categories,
    required this.onCategoryTap,
    required this.isLoading,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
      physics: appRefreshPhysics,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              16.h,
              16.w,
              0,
            ),
            child: const ServicesHeaderSection(),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(height: 28.h),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 4.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'services_pick_category'.tr(),
                        style: AppStyle.h6.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'services_category_list_hint'.tr(),
                        style: AppStyle.bodyXSmall.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(height: 16.h),
        ),

        if (!isLoading && categories.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyWidget(
              icon: Icons.handyman_outlined,
              iconSize: 48,
              iconColor: AppColors.grey,
              title: 'services_no_results'.tr(),
              subtitle: 'services_no_workshops_hint'.tr(),
              padding: EdgeInsets.symmetric(vertical: 32.h),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              0,
              16.w,
              28.h,
            ),
            sliver: SliverToBoxAdapter(
              child: Skeletonizer(
                enabled: isLoading,
                child: ServiceCategoryGrid(
                  categories: categories,
                  onCategoryTap: onCategoryTap,
                ),
              ),
            ),
          ),
      ],
    ),
    );
  }
}