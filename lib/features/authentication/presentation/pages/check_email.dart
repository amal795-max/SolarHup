import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/reset_password_bloc/reset_password_bloc.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white70,
                    title: const Text(
                      textAlign: TextAlign.center,
                      'How to change your password',
                    ),
                    content: const Text(
                      '1.Enter your registered email.\n'
                      '2.You will receive an OTP code in your email\n3. Enter the OTP code.\n4.Set new password and login with it',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.help_outline, color: AppColors.deepGrey),
          ),
          SizedBox(width: 12.w),
        ],
      ),

      body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listenWhen: _listenWhen,
        listener: _listener,
        builder: _builder,
      ),
    );
  }

  bool _listenWhen(previous, current) {
    return current is ResetPasswordSuccess || current is ResetPasswordFailure;
  }

  void _listener(BuildContext context, ResetPasswordState state) {
   context.read<ResetPasswordBloc>();
    if (state is ResetPasswordSuccess) {
      DataHelper.showSnackBar(
        message: state.message,
        context: context,
      );
      // Navigator.pushReplacementNamed(context, AppRoutes.otpVerify);
      // LocalStorage().saveData(
      //   key: ApiKeys.emailChecked,
      //   value: resetBloc.checkEmailController.text,
      // );
    }
    if (state is ResetPasswordFailure) {
      DataHelper.showSnackBar(
        message: state.message,
        context: context,
      );
    }
  }

  Widget _builder(BuildContext context, ResetPasswordState state) {
   context.read<ResetPasswordBloc>();


    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>const <dynamic>[

      ],
    );
  }
}
