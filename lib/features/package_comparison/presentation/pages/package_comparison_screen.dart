import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/package_comparison/data/data_source/package_comparison_remote_data_source.dart';
import 'package:untitled1/features/package_comparison/data/repositories/package_comparison_repository.dart';
import 'package:untitled1/features/package_comparison/presentation/bloc/package_comparison_bloc/package_comparison_bloc.dart';
import 'package:untitled1/features/package_comparison/presentation/widgets/package_comparison_actions_section.dart';
import 'package:untitled1/features/package_comparison/presentation/widgets/package_comparison_efficiency_section.dart';
import 'package:untitled1/features/package_comparison/presentation/widgets/package_comparison_header_section.dart';
import 'package:untitled1/features/package_comparison/presentation/widgets/package_comparison_pricing_section.dart';
import 'package:untitled1/features/package_comparison/presentation/widgets/package_comparison_product_cards_section.dart';
import 'package:untitled1/features/package_comparison/presentation/widgets/package_comparison_specs_section.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class PackageComparisonScreen extends StatelessWidget {
  const PackageComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PackageComparisonBloc(
        PackageComparisonRepositoryImpl(
          remote: const PackageComparisonRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(const LoadPackageComparisonEvent()),
      child: const _PackageComparisonView(),
    );
  }
}

class _PackageComparisonView extends StatelessWidget {
  const _PackageComparisonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<PackageComparisonBloc, PackageComparisonState>(
          listenWhen: (previous, current) =>
              current is PackageComparisonLoaded &&
              current.cartMessage != null &&
              (previous is! PackageComparisonLoaded ||
                  previous.cartMessage != current.cartMessage),
          listener: (context, state) {
            if (state is PackageComparisonLoaded &&
                state.cartMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.cartMessage!)),
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              PackageComparisonLoading() => const LoadingWidget(),
              PackageComparisonError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<PackageComparisonBloc>()
                        .add(const LoadPackageComparisonEvent()),
                    width: 160.w,
                  ),
                ),
              PackageComparisonLoaded() => _PackageComparisonBody(state: state),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _PackageComparisonBody extends StatelessWidget {
  final PackageComparisonLoaded state;

  const _PackageComparisonBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final comparison = state.comparison;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
          child: Row(
            children: [
              const BackButtonWidget(),
              Expanded(
                child: Text(
                  'package_comparison_title'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              SizedBox(width: 48.w),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PackageComparisonHeaderSection(),
                SizedBox(height: 16.h),
                PackageComparisonProductCardsSection(
                  starter: comparison.starter,
                  premium: comparison.premium,
                ),
                SizedBox(height: 12.h),
                PackageComparisonPricingSection(
                  starter: comparison.starter,
                  premium: comparison.premium,
                ),
                SizedBox(height: 12.h),
                PackageComparisonSpecsSection(
                  starter: comparison.starter,
                  premium: comparison.premium,
                ),
                SizedBox(height: 12.h),
                PackageComparisonEfficiencySection(
                  starter: comparison.starter,
                  premium: comparison.premium,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: PackageComparisonActionsSection(
            starter: comparison.starter,
            premium: comparison.premium,
            isAddingToCart: state.isAddingToCart,
            addingPackageId: state.addingPackageId,
            onAddStarter: () => context
                .read<PackageComparisonBloc>()
                .add(const AddStarterPackageEvent()),
            onAddPremium: () => context
                .read<PackageComparisonBloc>()
                .add(const AddPremiumPackageEvent()),
          ),
        ),
      ],
    );
  }
}
