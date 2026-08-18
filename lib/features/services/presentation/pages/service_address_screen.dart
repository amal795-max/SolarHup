import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/services/data/models/service_booking_draft.dart';
import 'package:untitled1/features/services/presentation/bloc/service_address_bloc/service_address_bloc.dart';
import 'package:untitled1/features/services/presentation/bloc/service_requests_cubit/service_requests_cubit.dart';
import 'package:untitled1/features/services/presentation/widgets/service_address_bottom_section.dart';
import 'package:untitled1/features/services/presentation/widgets/service_address_form_section.dart';
import 'package:untitled1/features/services/presentation/widgets/service_address_header_section.dart';
import 'package:untitled1/features/services/presentation/widgets/service_coupon_section.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/service_booking_step_indicator.dart';

class ServiceAddressScreen extends StatelessWidget {
  final String serviceId;
  final ServiceBookingDraft draft;

  const ServiceAddressScreen({
    super.key,
    required this.serviceId,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceAddressBloc(repository: getIt())
        ..add(
          LoadServiceAddressEvent(
            serviceId,
            servicePrice: draft.servicePrice,
          ),
        ),
      child: _ServiceAddressView(
        serviceId: serviceId,
        draft: draft,
      ),
    );
  }
}

class _ServiceAddressView extends StatelessWidget {
  final String serviceId;
  final ServiceBookingDraft draft;

  const _ServiceAddressView({
    required this.serviceId,
    required this.draft,
  });

  Future<void> _submitRequest(
    BuildContext context,
    ServiceAddressLoaded state,
  ) async {
    final updatedDraft = draft.copyWith(
      fullName: state.fullName,
      street: state.streetAddress,
      city: state.city,
      building: state.building,
      floor: state.floor.trim().isEmpty ? null : state.floor.trim(),
      couponCode: state.address.appliedCouponCode,
    );

    if (!updatedDraft.hasSchedule) {
     DataHelper.showSnackBar(message: 'schedule_select_time',context: context);
      return;
    }

    if (!updatedDraft.hasRequiredAddress) {
      DataHelper.showSnackBar(message: 'service_booking_required_fields',context: context);

      return;
    }

    final request = await context
        .read<ServiceRequestsCubit>()
        .requestService(updatedDraft.toPayload());

    if (!context.mounted || request == null) return;

    final originalPrice = draft.servicePrice;
    final finalPrice = double.tryParse(request.totalAmount) ?? originalPrice;
    final parsedDiscount = double.tryParse(request.discountAmount ?? '');
    final discountAmount = parsedDiscount ??
        (originalPrice - finalPrice).clamp(0, double.infinity);

    final confirmation = updatedDraft.toConfirmation(
      orderCode: request.orderCode,
      requestId: request.id,
      originalPrice: originalPrice,
      finalPrice: finalPrice,
      discountAmount: discountAmount > 0 ? discountAmount : null,
      couponCode: request.couponCode ?? state.address.appliedCouponCode,
    );

    context.pushReplacement(
      AppRoutes.bookingConfirmation(serviceId),
      extra: confirmation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<ServiceRequestsCubit, ServiceRequestsState>(
          listenWhen: (prev, curr) => curr is ServiceRequestsError,
          listener: (context, state) {
            if (state is ServiceRequestsError) {
              DataHelper.showSnackBar(message:state.message,context: context);

            }
          },
          builder: (context, requestState) {
            final isSubmitting = requestState is ServiceRequestsSubmitting;

            return BlocBuilder<ServiceAddressBloc, ServiceAddressState>(
              builder: (context, state) {
                if (state is ServiceAddressLoading || isSubmitting) {
                  return const LoadingIndicator();
                }

                if (state is! ServiceAddressLoaded) {
                  return const SizedBox.shrink();
                }

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
                    const ServiceBookingStepIndicator(
                      currentStep: ServiceBookingStep.address,
                    ),
                    SizedBox(height: 12.h),
                    const ServiceAddressHeaderSection(),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            ServiceAddressFormSection(state: state),
                            SizedBox(height: 16.h),
                            ServiceCouponSection(state: state),
                          ],
                        ),
                      ),
                    ),
                    ServiceAddressBottomSection(
                      state: state,
                      onConfirmTap: () => _submitRequest(context, state),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
