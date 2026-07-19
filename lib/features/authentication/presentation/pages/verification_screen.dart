import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/features/authentication/presentation/bloc/reset_password/reset_password_cubit.dart';
import 'package:untitled1/features/authentication/presentation/widgets/pinput.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/authentication/presentation/widgets/header.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/helper/local_storage.dart';
import '../../../../widgets/loader.dart';
import '../widgets/help_verify_widget.dart';
import '../widgets/white_section_widget.dart';

class VerificationScreen extends StatelessWidget {
  final bool isResetPassword;

  VerificationScreen({super.key, required this.isResetPassword});

  final String securityCode = LocalStorage().getData(key: ApiKeys.securityCode);

  Future<void> openTelegram(String username) async {
    final telegramApp = Uri.parse('tg://resolve?domain=$username');
    final telegramWeb = Uri.parse('https://t.me/$username');

    if (await canLaunchUrl(telegramApp)) {
      await launchUrl(telegramApp, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(telegramWeb, mode: LaunchMode.externalApplication);
    }
  }

  void _copySecurityCode() {
    final String code = securityCode;
    Clipboard.setData(ClipboardData(text: code));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: _listener,
      builder: _builder,
    );
  }

  void _listener(BuildContext context, ResetPasswordState state) {
    if (state is VerificationSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);
      !isResetPassword ? context.go(AppRoutes.bottomNavBar) : null;
    }    if (state is ConfirmOtpSuccess) {
      context.go(AppRoutes.resetPasswordScreen);
    }
    else if (state is VerificationFailure) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
  }

  Widget _builder(BuildContext context, ResetPasswordState state) {
    final cubit = context.read<ResetPasswordCubit>();
    if (state is VerificationLoading) {
      return const LoadingIndicator();
    }
    return Scaffold(
      appBar: !isResetPassword
          ? AppBar(
              automaticallyImplyLeading: false,
              actionsPadding: const EdgeInsets.all(12),
              actions: [
                IconButton(
                  onPressed: () => showHelpGuide(context),
                  icon: const Icon(Icons.help_outline, size: 24),
                ),
              ],
            )
          : null,
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
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isResetPassword) ...[
                      _buildSecurityCodeBox(),
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: 'go_to_telegram',
                        type: ButtonType.outlined,
                        onPressed: () =>
                            openTelegram('green_energy_system_bot'),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              'step_3_enter_otp'.tr(),
                              style: AppStyle.bodyXSmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],

                    pinPut(cubit.otpCodeController),
                    SizedBox(height: 24.h),

                    CustomButton(
                      text: 'verify_identity',
                      isLoading: state is ConfirmOtpLoading,
                      onPressed: () {
                        if (cubit.otpCodeController.text.isNotEmpty) {
                          cubit.confirmOtp(
                            isReset: isResetPassword ? true : false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: context.brightness
                      ? AppColors.lightYellow.withOpacity(0.5)
                      : context.colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20.sp,
                      color: AppColors.tertiaryColor,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'security_info'.tr(),
                        style: AppStyle.bodyXSmall.copyWith(
                          color: AppColors.tertiaryColor,
                        ),
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

  Widget _buildSecurityCodeBox() {
    final String code = securityCode;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'your_security_code'.tr(),
                style: AppStyle.bodyXSmall.copyWith(color: AppColors.grey),
              ),
              Text(
                code,
                style: AppStyle.bodyMedium.copyWith(
                  letterSpacing: 1.5,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _copySecurityCode,
            icon: Icon(
              Icons.copy_rounded,
              size: 22.sp,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
