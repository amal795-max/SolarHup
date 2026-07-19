import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/validators.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/authentication/presentation/bloc/reset_password/reset_password_cubit.dart';
import 'package:untitled1/features/authentication/presentation/widgets/header.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/theme/app_style.dart';
import '../widgets/white_section_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetPasswordCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            DataHelper.showSnackBar(message: state.message, context: context);
            context.go(AppRoutes.splashScreen);
            context.pop();
          } else if (state is ResetPasswordFailure) {
            DataHelper.showSnackBar(
              message: state.message,
              context: context,
              color: AppColors.red,
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child:  Column(
                children: [
                  headerWidget(
                    title: 'change_password',
                    subTitle: 'change_password_subtitle',
                  ),

                  whiteSectionWidget(
                    context: context,
                    child: Form(
                      key: cubit.changePasswordKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: cubit.oldPasswordController,
                            title: 'old_password'.tr(),
                            hint: 'enter_password_hint'.tr(),
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock_outline),
                            validator: passwordValidator,
                          ),
                          SizedBox(height: 8.h),

                          CustomTextField(
                            controller: cubit.newPasswordController,
                            title: 'new_password'.tr(),
                            hint: 'enter_password_hint'.tr(),
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock_outline),
                            validator: passwordValidator,
                          ),
                          InkWell(
                            onTap: () {
                              context.push(
                                AppRoutes.verificationScreen,
                                extra: true,
                              );
                              cubit.sendOtpVerification(
                                isReset: true,
                              );
                            },
                            child: Text(
                              'forget_password'.tr(),
                              style: AppStyle.labelXSmall,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: 'change'.tr(),
                                isLoading: state is ResetPasswordLoading,
                                onPressed: () {
                                  cubit.changePassword();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
