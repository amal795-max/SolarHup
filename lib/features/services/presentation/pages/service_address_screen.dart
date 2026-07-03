import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/routing/app_routes.dart';import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/data/data_source/service_address_remote_data_source.dart';
import 'package:untitled1/features/services/data/repositories/service_address_repository.dart';
import 'package:untitled1/features/services/presentation/bloc/service_address_bloc/service_address_bloc.dart';
import 'package:untitled1/features/services/presentation/widgets/service_address_bottom_section.dart';
import 'package:untitled1/features/services/presentation/widgets/service_address_form_section.dart';
import 'package:untitled1/features/services/presentation/widgets/service_address_header_section.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ServiceAddressScreen extends StatelessWidget {
  final String serviceId;

  const ServiceAddressScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceAddressBloc(
        ServiceAddressRepositoryImpl(
          remote: const ServiceAddressRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(LoadServiceAddressEvent(serviceId)),
      child: _ServiceAddressView(serviceId: serviceId),
    );
  }
}

class _ServiceAddressView extends StatelessWidget {
  final String serviceId;

  const _ServiceAddressView({required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ServiceAddressBloc, ServiceAddressState>(
          builder: (context, state) {
            return switch (state) {
              ServiceAddressLoading() => const LoadingWidget(),
              ServiceAddressError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<ServiceAddressBloc>()
                        .add(LoadServiceAddressEvent(serviceId)),
                    width: 160.w,
                  ),
                ),
              ServiceAddressLoaded() => _ServiceAddressBody(
                  state: state,
                  serviceId: serviceId,
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _ServiceAddressBody extends StatelessWidget {
  final ServiceAddressLoaded state;
  final String serviceId;

  const _ServiceAddressBody({
    required this.state,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: BackButtonWidget(),
          ),
        ),
        SizedBox(height: 8.h),
        const ServiceAddressHeaderSection(),
        SizedBox(height: 20.h),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ServiceAddressFormSection(state: state),
          ),
        ),
        ServiceAddressBottomSection(
          state: state,
          onConfirmTap: () => context.pushReplacement(
            AppRoutes.bookingConfirmation(serviceId),
          ),
        ),
      ],
    );
  }
}
