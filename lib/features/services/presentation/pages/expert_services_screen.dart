import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
import 'package:untitled1/widgets/app_skeletonizer.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

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
        child: BlocBuilder<ServiceCategoriesCubit, ServiceCategoriesState>(
          builder: (context, state) {
            return switch (state) {
              ServiceCategoriesLoading() => AppSkeletonizer(
                  child: _ServicesContent(
                    categories: List.generate(
                      5,
                      (index) => StoreCategoryModel(
                        id: index,
                        name: 'Loading category name',
                        type: 'workshop',
                      ),
                    ),
                    onCategoryTap: (_) {},
                  ),
                ),
              ServiceCategoriesError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<ServiceCategoriesCubit>()
                        .loadCategories(),
                    width: 160.w,
                  ),
                ),
              ServiceCategoriesLoaded(:final categories) => _ServicesContent(
                  categories: categories,
                  onCategoryTap: (category) {
                    context.push(
                      AppRoutes.workshopPickerScreen,
                      extra: WorkshopPickerRouteArgs(
                        categoryId: category.id,
                        categoryName: category.name,
                      ),
                    );
                  },
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _ServicesContent extends StatelessWidget {
  final List<StoreCategoryModel> categories;
  final ValueChanged<StoreCategoryModel> onCategoryTap;

  const _ServicesContent({
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: const ServicesHeaderSection(),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'services_pick_category'.tr(),
                  style: AppStyle.h6.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4.h),
                Text(
                  'services_category_list_hint'.tr(),
                  style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        if (categories.isEmpty)
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
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
            sliver: SliverToBoxAdapter(
              child: ServiceCategoryGrid(
                categories: categories,
                onCategoryTap: onCategoryTap,
              ),
            ),
          ),
      ],
    );
  }
}
