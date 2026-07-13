import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/authentication/presentation/widgets/header.dart';
import 'package:untitled1/widgets/primary_button.dart';

import '../../../../core/theme/app_themes.dart';
import '../widgets/white_section_widget.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>context.pop,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              headerWidget(
                title: 'verification',
                subTitle: 'verification_subtitle',
                ),
              whiteSectionWidget(
                child:Column(
                  children: [
                    Pinput(
                      // controller: resetBloc.otpCodeController,
                      length: 6,
                      defaultPinTheme: AppThemes.defaultPinTheme,
                      focusedPinTheme: AppThemes.focusedPinTheme,
                      keyboardType: TextInputType.text,
                      validator: (s) {
                        return s!.isEmpty ? 'Please enter the code' : null;
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                    ),

                    SizedBox(height: 32.h),
                    CustomButton(
                      text: 'verify_identity'.tr(),
                      onPressed: () {
                        context.push(AppRoutes.bottomNavBar);
                      },
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'didnt_receive_code'.tr(),
                      style: theme.textTheme.bodySmall,
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh, size: 18,color: AppColors.tertiaryColor,),
                      label: Text(
                        'resend_code'.tr(),
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: AppColors.tertiaryColor)
                      ),
                    ),
                  ],
                ), context: context,
              ),
              SizedBox(height: 32.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light ? Colors.grey[100]
                      : theme.colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20.sp, color: AppColors.grey),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'security_info'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
