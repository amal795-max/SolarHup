import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/reviews/presentation/bloc/reviews_cubit.dart';
import 'package:untitled1/features/reviews/presentation/widgets/review_form_widget.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';
import 'package:untitled1/features/services/presentation/widgets/rate_service_summary_card.dart';
import 'package:untitled1/widgets/back_button_widget.dart';

class RateServiceScreen extends StatelessWidget {
  final ServiceRequestModel request;

  const RateServiceScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReviewsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundGrey,
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Text('rate_service_title'.tr()),
          centerTitle: true,
          backgroundColor: AppColors.backGroundGrey,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RateServiceSummaryCard(request: request),
              SizedBox(height: 24.h),
              ReviewFormWidget(
                itemType: 'workshop',
                itemId: request.businessId.toString(),
                showContainer: false,
                titleKey: 'how_was_experience',
                submitButtonKey: 'submit_rating',
                showCommentLabel: false,
                submitIcon: Icons.send_rounded,
                onSuccess: () {
                  context.go(AppRoutes.activityScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
