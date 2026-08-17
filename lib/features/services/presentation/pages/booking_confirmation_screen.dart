import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/reviews/presentation/bloc/reviews_cubit.dart';
import 'package:untitled1/features/services/data/models/booking_confirmation_model.dart';
import 'package:untitled1/features/services/presentation/bloc/service_requests_cubit/service_requests_cubit.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_appointment_details_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_confirmation_actions_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_confirmation_header_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_rate_service_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_whats_next_section.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/back_button_widget.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final BookingConfirmationModel booking;
  final String? headerTitleKey;
  final String? headerSubtitleKey;
  final bool? showCancelButton;
  final bool showBackButton;
  final Future<void> Function()? onRefresh;

  const BookingConfirmationScreen({
    super.key,
    required this.booking,
    this.headerTitleKey,
    this.headerSubtitleKey,
    this.showCancelButton,
    this.showBackButton = false,
    this.onRefresh,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  late BookingConfirmationModel _booking;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  @override
  void didUpdateWidget(covariant BookingConfirmationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.booking != widget.booking) {
      _booking = widget.booking;
    }
  }

  bool get _canCancel =>
      widget.showCancelButton ?? (_booking.requestId != null && _booking.canCancel);

  Future<void> _cancelRequest() async {
    final requestId = _booking.requestId;
    if (requestId == null || !_canCancel || _isCancelling) return;

    setState(() => _isCancelling = true);

    final success = await context.read<ServiceRequestsCubit>().cancelRequest(
      requestId,
    );

    if (!mounted) return;

    setState(() => _isCancelling = false);

    if (success) {
      final state = context.read<ServiceRequestsCubit>().state;
      if (state is ServiceRequestDetailsLoaded &&
          state.request.id == requestId) {
        setState(() {
          _booking = state.request.toBookingConfirmation();
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('service_request_cancelled_success'.tr())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('stores_error_title'.tr())),
      );
    }
  }

  Future<void> _handleRefresh() async {
    final requestId = _booking.requestId;
    if (requestId == null) return;

    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    } else {
      final cubit = context.read<ServiceRequestsCubit>();
      await cubit.loadRequestDetail(requestId);
    }

    if (!mounted) return;

    final cubit = context.read<ServiceRequestsCubit>();
    final state = cubit.state;
    if (state is ServiceRequestDetailsLoaded && state.request.id == requestId) {
      setState(() {
        _booking = state.request.toBookingConfirmation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollContent = SingleChildScrollView(
      physics: appRefreshPhysics,
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
      child: Column(
        children: [
          BookingConfirmationHeaderSection(
            titleKey: widget.headerTitleKey,
            subtitleKey: widget.headerSubtitleKey,
          ),
          SizedBox(height: 24.h),
          BookingAppointmentDetailsSection(
            booking: _booking,
          ),
          SizedBox(height: 24.h),
          if (_booking.isCompleted)
            BlocProvider(
              create: (_) => getIt<ReviewsCubit>(),
              child: BookingRateServiceSection(
                businessId: _booking.businessId ?? 0,
              ),
            )
          else
            const BookingWhatsNextSection(),
        ],
      ),
    );

    final refreshableScroll = _booking.requestId != null
        ? AppRefreshIndicator(
            onRefresh: _handleRefresh,
            child: scrollContent,
          )
        : scrollContent;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            if (widget.showBackButton)
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: BackButtonWidget(),
                ),
              ),
            Expanded(child: refreshableScroll),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: BookingConfirmationActionsSection(
                showCancelButton: _canCancel,
                isCancelling: _isCancelling,
                onCancelTap: _cancelRequest,
                onBackHomeTap: () => context.go(AppRoutes.bottomNavBar),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
