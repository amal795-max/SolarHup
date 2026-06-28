import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/validators.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
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
      listener: (context, state) {
        if(state is AuthenticationSuccess){
          print(state.isExists);
          state.isExists?
          context.pushReplacement(AppRoutes.loginScreen):
          context.pushReplacement(AppRoutes.registerScreen);
        }
        else if(state is AuthenticationFailure){
          DataHelper.showSnackBar(message: state.message, context: context);
        }
      },
      builder: (context, state) {
        if(state is AuthenticationLoading) {
          return const LoadingWidget();
        }
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: <Widget>[
                  headerWidget(
                    icon: Icons.solar_power_rounded,
                    title: 'Welcome to SolarHub',
                    subTitle: 'Sustainable energy, managed simply.',
                  ),

                  Form(
                    key: context.read<AuthenticationCubit>().authKey,
                    child: whiteSectionWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller:context.read<AuthenticationCubit>().phoneNumberController,
                              validator: (val)=>phoneValid(val),
                              title: 'phone_number'.tr(),
                              hint: '+963 000 000 000',
                              keyboardType: TextInputType.phone,
                              prefixIcon: const Icon(Icons.phone)
                          ),
                          SizedBox(height: 8.h),
                          CustomButton(
                            text: 'Continue',
                            onPressed: () {
                              context.read<AuthenticationCubit>().checkPhoneNumber();
                              },
                            textColor: AppColors.white,
                          ),
                        ],
                      ), context: context,
                    ),
                  ),

                  const SizedBox(height: 32,),
                  Text(
                    'Need help accessing your account? Contact',
                    style: AppStyle.bodyXSmall.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Support',
                      style: AppStyle.bodyXSmall.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
