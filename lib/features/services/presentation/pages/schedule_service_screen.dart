import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/services/data/data_source/schedule_service_remote_data_source.dart';
import 'package:untitled1/features/services/data/repositories/schedule_service_repository.dart';
import 'package:untitled1/features/services/presentation/bloc/schedule_service_bloc/schedule_service_bloc.dart';
import 'package:untitled1/features/services/presentation/widgets/schedule_appointment_summary.dart';
import 'package:untitled1/features/services/presentation/widgets/schedule_date_section.dart';
import 'package:untitled1/features/services/presentation/widgets/schedule_form_section.dart';
import 'package:untitled1/features/services/presentation/widgets/schedule_service_hero_section.dart';
import 'package:untitled1/features/services/presentation/widgets/schedule_time_section.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ScheduleServiceScreen extends StatelessWidget {
  final String serviceId;

  const ScheduleServiceScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleServiceBloc(
        ScheduleServiceRepositoryImpl(
          remote: const ScheduleServiceRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(LoadScheduleServiceEvent(serviceId)),
      child: _ScheduleServiceView(serviceId: serviceId),
    );
  }
}

class _ScheduleServiceView extends StatelessWidget {
  final String serviceId;

  const _ScheduleServiceView({required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ScheduleServiceBloc, ScheduleServiceState>(
          builder: (context, state) {
            return switch (state) {
              ScheduleServiceLoading() => const LoadingIndicator(),
              ScheduleServiceError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<ScheduleServiceBloc>()
                        .add(LoadScheduleServiceEvent(serviceId)),
                    width: 160.w,
                  ),
                ),
              ScheduleServiceLoaded() =>
                _ScheduleServiceBody(state: state, serviceId: serviceId),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _ScheduleServiceBody extends StatelessWidget {
  final ScheduleServiceLoaded state;
  final String serviceId;

  const _ScheduleServiceBody({
    required this.state,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
          child: Row(
            children: [
              const BackButtonWidget(),
              Expanded(
                child: Text(
                  'schedule_service_title'.tr(),
                  style: AppStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: headingColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScheduleServiceHeroSection(service: state.service),
                SizedBox(height: 20.h),
                ScheduleDateSection(state: state),
                SizedBox(height: 20.h),
                ScheduleTimeSection(state: state),
                SizedBox(height: 20.h),
                const ScheduleFormSection(),
                SizedBox(height: 20.h),
                ScheduleAppointmentSummary(state: state),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'continue'.tr(),
                  onPressed: () =>
                      context.push(AppRoutes.serviceAddress(serviceId)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
