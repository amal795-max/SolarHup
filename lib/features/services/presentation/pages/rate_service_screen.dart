import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/data/data_source/service_rating_remote_data_source.dart';
import 'package:untitled1/features/services/data/repositories/service_rating_repository.dart';
import 'package:untitled1/features/services/presentation/bloc/service_rating_bloc/service_rating_bloc.dart';
import 'package:untitled1/features/services/presentation/widgets/rate_service_detailed_ratings_section.dart';
import 'package:untitled1/features/services/presentation/widgets/rate_service_experience_section.dart';
import 'package:untitled1/features/services/presentation/widgets/rate_service_photos_section.dart';
import 'package:untitled1/features/services/presentation/widgets/rate_service_summary_card.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class RateServiceScreen extends StatelessWidget {
  final String serviceId;

  const RateServiceScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceRatingBloc(
        ServiceRatingRepositoryImpl(
          remote: const ServiceRatingRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(LoadServiceRatingEvent(serviceId)),
      child: _RateServiceView(serviceId: serviceId),
    );
  }
}

class _RateServiceView extends StatelessWidget {
  final String serviceId;

  const _RateServiceView({required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<ServiceRatingBloc, ServiceRatingState>(
          listenWhen: (previous, current) =>
              current is ServiceRatingLoaded &&
              (current.isSubmitted ||
                  (current.submitError != null &&
                      (previous is! ServiceRatingLoaded ||
                          previous.submitError != current.submitError))),
          listener: (context, state) {
            if (state is! ServiceRatingLoaded) return;
            if (state.isSubmitted) {
              context.go(AppRoutes.activityScreen);
              return;
            }
            if (state.submitError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.submitError!)),
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              ServiceRatingLoading() => const LoadingIndicator(),
              ServiceRatingError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<ServiceRatingBloc>()
                        .add(LoadServiceRatingEvent(serviceId)),
                    width: 160.w,
                  ),
                ),
              ServiceRatingLoaded() => _RateServiceBody(state: state),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _RateServiceBody extends StatelessWidget {
  final ServiceRatingLoaded state;

  const _RateServiceBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
          child: Row(
            children: [
              const BackButtonWidget(),
              Expanded(
                child: Text(
                  'rate_service_title'.tr(),
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
              children: [
                RateServiceSummaryCard(rating: state.rating),
                SizedBox(height: 20.h),
                RateServiceExperienceSection(state: state),
                SizedBox(height: 16.h),
                RateServiceDetailedRatingsSection(state: state),
                SizedBox(height: 20.h),
                RateServicePhotosSection(state: state),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'submit_rating'.tr(),
                  icon: Icons.send_rounded,
                  iconLeft: true,
                  backgroundColor: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  isLoading: state.isSubmitting,
                  onPressed: state.isSubmitting
                      ? null
                      : () => context
                          .read<ServiceRatingBloc>()
                          .add(const SubmitServiceRatingEvent()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
