import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/primary_button.dart';

/// Full-width dark banner at the bottom of the store info page.
/// Shows an advisory message with "Schedule Call" and "Live Chat" action buttons.
class StoreInfoExpertSection extends StatelessWidget {
  const StoreInfoExpertSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Heading ──────────────────────────────────────────────────────
          Text(
            'store_info_expert_title'.tr(),
            style: AppStyle.h6.copyWith(color: AppColors.white),
          ),

          SizedBox(height: 6.h),

          // ── Subtitle ─────────────────────────────────────────────────────
          Text(
            'store_info_expert_subtitle'.tr(),
            style: AppStyle.labelSmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.75),
              height: 1.5,
            ),
          ),

          SizedBox(height: 18.h),

          // ── Action buttons ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'store_info_schedule_call'.tr(),
                  type: ButtonType.outlined,
                  borderColor: AppColors.white.withValues(alpha: 0.6),
                  textColor: AppColors.white,
                  height: 44.h,
                  onPressed: () {
                    // TODO: open call scheduling flow
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  text: 'store_info_live_chat'.tr(),
                  type: ButtonType.outlined,
                  borderColor: AppColors.secondaryColor.withValues(alpha: 0.8),
                  textColor: AppColors.secondaryColor,
                  height: 44.h,
                  onPressed: () {
                    // TODO: open live chat
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
