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

import '../widgets/white_section_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
  });

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
            DataHelper.showSnackBar(
              message: state.message,
              context: context,
            );
            context.go(AppRoutes.splashScreen);
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
            child: Form(
              key:cubit.resetPasswordKey,
              child: Column(
                children: [
                  headerWidget(
                    title: 'reset_password',
                    subTitle: 'reset_password_subtitle',
                  ),
                  whiteSectionWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller:cubit.newPasswordController,
                          title: 'new_password'.tr(),
                          hint: 'enter_password_hint'.tr(),
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                          validator: passwordValidator,
                        ),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller:cubit.confirmPasswordController,
                          title: 'confirm_password'.tr(),
                          hint: 'enter_password_hint'.tr(),
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'validation_required'.tr();
                            }
                            if (value != cubit.newPasswordController.text
                            ) {
                            return 'passwords_do_not_match'.tr();
                            }
                            return
                            null;
                          },
                        ),
                        SizedBox(height: 12.h),
                        BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: 'reset'.tr(),
                              isLoading: state is ResetPasswordLoading,
                              onPressed: () {
                                cubit.setNewPassword();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    context: context,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
