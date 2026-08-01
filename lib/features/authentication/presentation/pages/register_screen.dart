import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/validators.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../widgets/loader.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/header.dart';
import '../widgets/white_section_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: _listen,
      builder: _builder,
    );
  }

  void _listen(BuildContext context, AuthenticationState state) {
    if (state is RegisterSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);
      context.go(AppRoutes.bottomNavBar);

    }
    if (state is AuthenticationFailure) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
  }

  Widget _builder(BuildContext context, AuthenticationState state) {
    final authBloc = context.read<AuthenticationCubit>();
    if (state is AuthenticationLoading) {
      return const LoadingIndicator();
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: <Widget>[
              headerWidget(
                title: 'join_top_solar',
                subTitle: 'complete_details',
              ),
              whiteSectionWidget(
                context: context,
                child: Form(
                  key: authBloc.registerKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: authBloc.passwordController,
                        validator: passwordValidator,
                        title: 'password'.tr(),
                        hint: 'enter_password_hint'.tr(),
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.lock_outline_sharp),
                        isPassword: true,
                      ),

                      SizedBox(height: 8.h),

                      CustomButton(
                        text: 'create_account'.tr(),
                        onPressed: () {
                          authBloc.register();
                        },
                        textColor: AppColors.white,
                        icon: Icons.arrow_forward_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
