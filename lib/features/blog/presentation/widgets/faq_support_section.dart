import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/widgets/primary_button.dart';

class FaqSupportSection extends StatelessWidget {
  final VoidCallback? onContactTap;

  const FaqSupportSection({super.key, this.onContactTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background =
        isDark ? theme.colorScheme.tertiaryContainer : AppColors.lightGrey;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            'faq_still_have_questions'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'faq_support_description'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.grey,
              height: 1.45,
            ),
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'faq_contact_support'.tr(),
            icon: Icons.headset_mic_outlined,
            iconLeft: true,
            onPressed: onContactTap,
            backgroundColor: AppColors.primaryColor,
            textColor: AppColors.white,
            height: 48.h,
            borderRadius: 24,
          ),
        ],
      ),
    );
  }
}
