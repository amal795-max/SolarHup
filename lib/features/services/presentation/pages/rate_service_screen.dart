import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/reviews/presentation/widgets/review_form_widget.dart';
import 'package:untitled1/widgets/back_button_widget.dart';

class RateServiceScreen extends StatelessWidget {
  final String serviceId;

  const RateServiceScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Text('rate_service_title'.tr()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'service_id'.tr(args: [serviceId]),
                style: AppStyle.labelMedium,
              ),
              SizedBox(height: 20.h),
              ReviewFormWidget(
                itemType: 'service',
                itemId: serviceId,
                onSuccess: () {
                  context.go(AppRoutes.activityScreen);
                },
              ),
            ],
          ),
        ),

    );
  }
}
