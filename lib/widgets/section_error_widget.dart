import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

/// Compact inline error for a single screen section (e.g. home page blocks).
class SectionErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const SectionErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      icon: Icons.error_outline,
      iconSize: 32,
      iconColor: AppColors.red,
      title: 'stores_error_title',
      subtitle: message.tr(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: MainAxisAlignment.start,
      action: onRetry == null
          ? null
          : CustomButton(
              text: 'stores_retry'.tr(),
              icon: Icons.refresh_rounded,
              iconLeft: true,
              onPressed: onRetry,
              width: 140.w,
            ),
    );
  }
}
