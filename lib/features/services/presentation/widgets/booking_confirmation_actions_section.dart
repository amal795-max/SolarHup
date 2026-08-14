import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BookingConfirmationActionsSection extends StatelessWidget {
  final VoidCallback? onViewBookingsTap;
  final VoidCallback? onBackHomeTap;
  final bool showCancelButton;
  final bool isCancelling;
  final VoidCallback? onCancelTap;

  const BookingConfirmationActionsSection({
    super.key,
    this.onViewBookingsTap,
    this.onBackHomeTap,
    this.showCancelButton = false,
    this.isCancelling = false,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showCancelButton) ...[
          CustomButton(
            text: 'cancel_service_request_btn'.tr(),
            type: ButtonType.outlined,
            onPressed: isCancelling ? null : onCancelTap,
            isLoading: isCancelling,
          ),
          SizedBox(height: 10.h),
        ],
        CustomButton(
          text: 'btn_view_bookings'.tr(),
          onPressed: onViewBookingsTap,
        ),
        SizedBox(height: 10.h),
        CustomButton(
          text: 'btn_back_home'.tr(),
          type: ButtonType.outlined,
          onPressed: onBackHomeTap,
        ),
      ],
    );
  }
}
