import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

enum ServiceBookingStep { schedule, address, confirm }

class ServiceBookingStepIndicator extends StatelessWidget {
  final ServiceBookingStep currentStep;

  const ServiceBookingStepIndicator({
    super.key,
    required this.currentStep,
  });

  int get _currentIndex => ServiceBookingStep.values.indexOf(currentStep);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.blue : AppColors.primaryColor;
    const labels = [
      'booking_step_schedule',
      'booking_step_address',
      'booking_step_confirm',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < _currentIndex;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2.h,
                margin: EdgeInsets.only(bottom: 18.h),
                color: isCompleted
                    ? AppColors.secondaryColor
                    : AppColors.grey.withValues(alpha: 0.25),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < _currentIndex;
          final isActive = stepIndex == _currentIndex;

          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isActive
                      ? (isActive ? activeColor : AppColors.secondaryColor)
                      : AppColors.grey.withValues(alpha: 0.15),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.25),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(Icons.check_rounded, color: AppColors.white, size: 16.sp)
                      : Text(
                          '${stepIndex + 1}',
                          style: AppStyle.labelSmall.copyWith(
                            color: isActive ? AppColors.white : AppColors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                width: 72.w,
                child: Text(
                  labels[stepIndex].tr(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.labelXSmall.copyWith(
                    color: isActive ? activeColor : AppColors.grey,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
