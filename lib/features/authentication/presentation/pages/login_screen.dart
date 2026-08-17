import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/validators.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../widgets/loader.dart';
import '../bloc/authentication_cubit.dart';
import '../widgets/white_section_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: _listener,
      builder: _builder,
    );
  }

  void _listener(BuildContext context, AuthenticationState state) {
    if (state is LoginSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);
      context.go(AppRoutes.bottomNavBar);
    } else if (state is LoginFailure) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
  }

  Widget _builder(BuildContext context, AuthenticationState state) {
    final authBloc = context.read<AuthenticationCubit>();
    if (state is LoginLoading) {
      return const LoadingIndicator();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imageWidget(),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Form(
                key: authBloc.loginKey,
                child: Column(
                  children: [
                    whiteSectionWidget(
                      context: context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            title: 'password'.tr(),
                            hint: 'enter_password_hint'.tr(),
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock_outline),
                            validator: passwordValidator,
                            controller: authBloc.passwordController,
                          ),
                          InkWell(
                            onTap: () {
                              context.push(AppRoutes.resetPasswordScreen);
                            },
                            child: Text(
                              'forget_password'.tr(),
                              style: AppStyle.labelXSmall,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          CustomButton(
                            text: 'login'.tr(),
                            onPressed: () {
                              authBloc.login();
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack _imageWidget() {
    return Stack(
      children: [
        Container(
          height: 0.28.sh,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),

            image: const DecorationImage(
              image: AssetImage(AppImages.solrPanelsIcon),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 0.28.sh,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black12, Colors.black87],
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'welcome_back'.tr(),
                style: AppStyle.h3.copyWith(color: Colors.white),
              ),
              SizedBox(height: 8.h),
              Text(
                'sign_in_subtitle'.tr(),
                style: AppStyle.bodySmall.copyWith(
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
