import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/data/data_source/services_remote_data_source.dart';
import 'package:untitled1/features/services/data/repositories/services_repository.dart';
import 'package:untitled1/features/services/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:untitled1/features/services/presentation/widgets/featured_service_card.dart';
import 'package:untitled1/features/services/presentation/widgets/service_card.dart';
import 'package:untitled1/features/services/presentation/widgets/services_category_section.dart';
import 'package:untitled1/features/services/presentation/widgets/services_header_section.dart';
import 'package:untitled1/features/services/presentation/widgets/services_search_section.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ExpertServicesScreen extends StatelessWidget {
  const ExpertServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServicesBloc(
        ServicesRepositoryImpl(
          remote: const ServicesRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(const LoadServicesEvent()),
      child: const _ExpertServicesView(),
    );
  }
}

class _ExpertServicesView extends StatelessWidget {
  const _ExpertServicesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            return switch (state) {
              ServicesLoading() => const LoadingWidget(),
              ServicesError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<ServicesBloc>()
                        .add(const LoadServicesEvent()),
                    width: 160.w,
                  ),
                ),
              ServicesLoaded() => _ExpertServicesBody(state: state),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _ExpertServicesBody extends StatelessWidget {
  final ServicesLoaded state;

  const _ExpertServicesBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final services = state.filteredServices;
    final featured = state.featured;
    final showFeatured = featured != null &&
        (state.selectedCategoryIndex == 0 ||
            (state.selectedCategoryIndex == 1 &&
                featured.categoryKey == 'maintenance') ||
            (state.selectedCategoryIndex == 2 &&
                featured.categoryKey == 'installation'));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ServicesHeaderSection(),
          SizedBox(height: 16.h),
          const ServicesSearchSection(),
          SizedBox(height: 4.h),
          const ServicesCategorySection(),
          SizedBox(height: 16.h),
          if (services.isEmpty && !showFeatured)
            EmptyWidget(
              icon: Icons.search_off_rounded,
              iconSize: 48,
              iconColor: AppColors.grey,
              title: 'services_no_results'.tr(),
              subtitle: 'blog_no_results_hint'.tr(),
              padding: EdgeInsets.symmetric(vertical: 32.h),
            )
          else ...[
            ...services.map(
              (service) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: ServiceCard(service: service),
              ),
            ),
            if (showFeatured) ...[
              SizedBox(height: 4.h),
              FeaturedServiceCard(service: featured),
            ],
          ],
        ],
      ),
    );
  }
}
