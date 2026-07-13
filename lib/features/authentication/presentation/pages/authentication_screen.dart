import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/validators.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:untitled1/features/authentication/presentation/widgets/header.dart';
import 'package:untitled1/widgets/loader.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/white_section_widget.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: _listen,
      builder: _builder,
    );
  }

  void _listen(BuildContext context, AuthenticationState state) {
    if (state is AuthenticationSuccess) {
      state.isExists
          ? context.pushReplacement(AppRoutes.loginScreen)
          : context.pushReplacement(AppRoutes.registerScreen);
    }
    else if (state is AuthenticationFailure) {
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
           child:  Column(
              children: <Widget>[
                headerWidget(
                  title: 'auth_solar_top',
                  subTitle: 'auth_solar_top_sub',
                ),
                Form(
                  key: authBloc.authKey,
                  child: whiteSectionWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          // textDirection: TextDirection.RTL,
                          controller: authBloc.phoneNumberController,
                          validator: (val) => phoneValid(val),
                          maxLength: 10,
                          title: 'phone_number'.tr(),
                          hint: '09XX XXX XXX',
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone),
                        )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 300.ms)
                            .slideX(begin: -0.2, end: 0, duration: 500.ms),

                        SizedBox(height: 8.h),

                        CustomButton(

                          text: 'continue',
                          onPressed: () {
                            // authBloc.checkPhoneNumber();
                            context.push(AppRoutes.registerScreen);
                          },
                          textColor: AppColors.white,
                          icon: Icons.arrow_forward_rounded,
                        )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 600.ms)
                      ],
                    ),
                    context: context,
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
