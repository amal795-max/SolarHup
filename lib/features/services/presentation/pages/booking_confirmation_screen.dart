import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/services/data/models/booking_confirmation_model.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_appointment_details_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_confirmation_actions_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_confirmation_header_section.dart';
import 'package:untitled1/features/services/presentation/widgets/booking_whats_next_section.dart';
import 'package:untitled1/widgets/back_button_widget.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final BookingConfirmationModel booking;
  final String? headerTitleKey;
  final String? headerSubtitleKey;
  final bool showCancelButton;
  final bool isCancelling;
  final VoidCallback? onCancelTap;
  final bool showBackButton;

  const BookingConfirmationScreen({
    super.key,
    required this.booking,
    this.headerTitleKey,
    this.headerSubtitleKey,
    this.showCancelButton = false,
    this.isCancelling = false,
    this.onCancelTap,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            if (showBackButton)
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: BackButtonWidget(),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
                child: Column(
                  children: [
                    BookingConfirmationHeaderSection(
                      titleKey: headerTitleKey,
                      subtitleKey: headerSubtitleKey,
                    ),
                    SizedBox(height: 24.h),
                    BookingAppointmentDetailsSection(
                      booking: booking,
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
                showCancelButton: showCancelButton,
                isCancelling: isCancelling,
                onCancelTap: onCancelTap,
                onViewBookingsTap: () => context.go(AppRoutes.activityScreen),
                onBackHomeTap: () => context.go(AppRoutes.bottomNavBar),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
