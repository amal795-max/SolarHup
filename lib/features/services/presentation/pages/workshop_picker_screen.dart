import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/helper/user_city_preference.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/services/presentation/bloc/workshop_picker_cubit/workshop_picker_cubit.dart';
import 'package:untitled1/features/services/presentation/mappers/workshop_picker_mapper.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_info_route_args.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_picker_route_args.dart';
import 'package:untitled1/features/services/presentation/widgets/workshop_picker_card.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/app_skeletonizer.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';

class WorkshopPickerScreen extends StatelessWidget {
  final WorkshopPickerRouteArgs args;

  const WorkshopPickerScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkshopPickerCubit>()
        ..loadOfferings(
          categoryId: args.categoryId,
          categoryName: args.categoryName,
        ),
      child: _WorkshopPickerView(args: args),
    );
  }
}

class _WorkshopPickerView extends StatefulWidget {
  final WorkshopPickerRouteArgs args;

  const _WorkshopPickerView({required this.args});

  @override
  State<_WorkshopPickerView> createState() => _WorkshopPickerViewState();
}

class _WorkshopPickerViewState extends State<_WorkshopPickerView> {
  @override
  void initState() {
    super.initState();
    UserCityPreference.cityNotifier.addListener(_onCityChanged);
  }

  void _onCityChanged() {
    if (!mounted) return;
    context.read<WorkshopPickerCubit>().loadOfferings(
          categoryId: widget.args.categoryId,
          categoryName: widget.args.categoryName,
          showLoading: true,
        );
  }

  @override
  void dispose() {
    UserCityPreference.cityNotifier.removeListener(_onCityChanged);
    super.dispose();
  }

  void _loadOfferings({bool showLoading = false}) {
    context.read<WorkshopPickerCubit>().loadOfferings(
          categoryId: widget.args.categoryId,
          categoryName: widget.args.categoryName,
          showLoading: showLoading,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final args = widget.args;

    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : AppColors.backGroundGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 0),
              child: const BackButtonWidget(),
            ),
            Expanded(
              child: BlocBuilder<WorkshopPickerCubit, WorkshopPickerState>(
                builder: (context, state) {
                  return switch (state) {
                    WorkshopPickerLoading() => AppSkeletonizer(
                        isLoading: true,
                        hasCachedData: false,
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                          children: [
                            _CategoryHeroHeader(categoryName: args.categoryName),
                            SizedBox(height: 16.h),
                            ...List.generate(
                              3,
                              (_) => Container(
                                height: 200.h,
                                margin: EdgeInsets.only(bottom: 16.h),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    WorkshopPickerError(:final message) => errorWidget(
                        message: message,
                        hasButton: true,
                        onPressed: () => _loadOfferings(showLoading: true),
                      ),
                    WorkshopPickerLoaded(:final offerings) => _PickerContent(
                        args: args,
                        groups: groupOfferingsByWorkshop(offerings),
                        onRefresh: () async => _loadOfferings(),
                      ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerContent extends StatelessWidget {
  final WorkshopPickerRouteArgs args;
  final List<WorkshopPickerGroup> groups;
  final Future<void> Function()? onRefresh;

  const _PickerContent({
    required this.args,
    required this.groups,
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
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: _CategoryHeroHeader(categoryName: args.categoryName),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'services_choose_workshop'.tr(),
                  style: AppStyle.h6.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4.h),
                Text(
                  'workshop_picker_list_hint'.tr(),
                  style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        if (groups.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyWidget(
              icon: Icons.search_off_rounded,
              iconSize: 48,
              iconColor: AppColors.grey,
              title: 'services_no_workshops'.tr(),
              subtitle: 'services_no_workshops_hint'.tr(),
              padding: EdgeInsets.symmetric(vertical: 32.h),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final group = groups[index];
                  return WorkshopPickerCard(
                    group: group,
                    onTap: () => context.push(
                      AppRoutes.workshopInfoScreen,
                      extra: WorkshopInfoRouteArgs(
                        workshopId: group.workshopId,
                        categoryId: args.categoryId,
                        highlightServiceId: group.highlightServiceId,
                      ),
                    ),
                  );
                },
                childCount: groups.length,
              ),
            ),
          ),
      ],
    ),
    );
  }
}

class _CategoryHeroHeader extends StatelessWidget {
  final String categoryName;

  const _CategoryHeroHeader({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryColor, AppColors.deepPrimaryColor],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.handyman_rounded,
                color: AppColors.secondaryColor,
                size: 28.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'services_selected_category'.tr(),
                    style: AppStyle.labelXSmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    categoryName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.h6.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
