import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:untitled1/widgets/error_widget.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().getPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('privacy_policy'.tr(),),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsError) {
            return errorWidget(
              message: state.message,
              hasButton: true,
              onPressed: () => context.read<SettingsCubit>().getPrivacyPolicy(),
            );
          }

          bool isLoading = state is PrivacyPolicyLoading ;
          final privacyPolicy = state is PrivacyPolicySuccess ? state.privacyPolicy : null;

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (privacyPolicy != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      'privacy_policy_updated_at'.tr(
                          args: [
                        DataHelper.dateFormat('yyyy-MM-dd',privacyPolicy.updatedAt,locale: context.locale)
                      ]),
                      style: AppStyle.bodySmall.copyWith(color:AppColors.grey),
                    ),
                  ] ,
                  Html(
                    data: privacyPolicy?.content ?? '<p>Loading...</p>',
                    style: {
                      'body': Style(
                        fontSize: FontSize(14.sp),
                        lineHeight: const LineHeight(1.3),
                      ),
                      'h2': Style(
                        color: AppColors.primaryColor
                      ),
                    },
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
