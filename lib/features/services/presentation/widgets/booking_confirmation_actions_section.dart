import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BookingConfirmationActionsSection extends StatelessWidget {
  final VoidCallback? onBackHomeTap;
  final bool showCancelButton;
  final bool isCancelling;
  final VoidCallback? onCancelTap;

  const BookingConfirmationActionsSection({
    super.key,
    this.onBackHomeTap,
    this.showCancelButton = false,
    this.isCancelling = false,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onBackHomeTap != null)
          CustomButton(
            text: 'btn_back_home'.tr(),
            onPressed: onBackHomeTap,
          ),
        if (showCancelButton) ...[
          if (onBackHomeTap != null) SizedBox(height: 10.h),
          CustomButton(
            text: 'cancel_service_request_btn'.tr(),
            type: ButtonType.outlined,
            onPressed: isCancelling ? null : onCancelTap,
            isLoading: isCancelling,
          ),
        ],
      ],
    );
  }
}
