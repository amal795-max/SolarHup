import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/features/authentication/presentation/widgets/header.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';

import '../widgets/white_section_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
   Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all( 20.w),
          child: Column(
            children: [
             headerWidget(
               title: 'reset_password',
               subTitle: 'reset_password_subtitle',),

              whiteSectionWidget(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      title: 'new_password'.tr(),
                      hint: 'enter_password_hint'.tr(),
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      title: 'confirm_password'.tr(),
                      hint: 'enter_password_hint'.tr(),
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    SizedBox(height: 12.h),
                    CustomButton(
                      text: 'reset'.tr(),
                      onPressed: () {},
                    ),
                  ],
                ), context: context,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
