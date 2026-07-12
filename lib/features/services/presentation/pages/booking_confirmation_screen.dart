import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/data/data_source/booking_confirmation_remote_data_source.dart';
import 'package:untitled1/features/services/data/repositories/booking_confirmation_repository.dart';
import 'package:untitled1/features/services/presentation/bloc/booking_confirmation_bloc/booking_confirmation_bloc.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_appointment_details_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_confirmation_actions_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_confirmation_header_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_whats_next_section.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String serviceId;

  const BookingConfirmationScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingConfirmationBloc(
        BookingConfirmationRepositoryImpl(
          remote: const BookingConfirmationRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(LoadBookingConfirmationEvent(serviceId)),
      child: _BookingConfirmationView(serviceId: serviceId),
    );
  }
}

class _BookingConfirmationView extends StatelessWidget {
  final String serviceId;

  const _BookingConfirmationView({required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<BookingConfirmationBloc, BookingConfirmationState>(
          listenWhen: (previous, current) =>
              current is BookingConfirmationLoaded &&
              current.receiptMessage != null &&
              (previous is! BookingConfirmationLoaded ||
                  previous.receiptMessage != current.receiptMessage),
          listener: (context, state) {
            if (state is BookingConfirmationLoaded &&
                state.receiptMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.receiptMessage!)),
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              BookingConfirmationLoading() => const LoadingIndicator(),
              BookingConfirmationError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<BookingConfirmationBloc>()
                        .add(LoadBookingConfirmationEvent(serviceId)),
                    width: 160.w,
                  ),
                ),
              BookingConfirmationLoaded() => _BookingConfirmationBody(
                  state: state,
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _BookingConfirmationBody extends StatelessWidget {
  final BookingConfirmationLoaded state;

  const _BookingConfirmationBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
            child: Column(
              children: [
                const BookingConfirmationHeaderSection(),
                SizedBox(height: 24.h),
                BookingAppointmentDetailsSection(
                  booking: state.booking,
                  isDownloadingReceipt: state.isDownloadingReceipt,
                  onReceiptTap: () => context.read<BookingConfirmationBloc>().add(
                        DownloadBookingReceiptEvent(state.booking.bookingId),
                      ),
                ),
                SizedBox(height: 24.h),
                const BookingWhatsNextSection(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: BookingConfirmationActionsSection(
            onViewBookingsTap: () => context.go(AppRoutes.activityScreen),
            onBackHomeTap: () => context.go(AppRoutes.bottomNavBar),
          ),
        ),
      ],
    );
  }
}
