import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/presentation/widgets/rate_order_summary_card.dart';
import 'package:untitled1/features/reviews/presentation/bloc/reviews_cubit.dart';
import 'package:untitled1/features/reviews/presentation/widgets/rate_review_section.dart';
import 'package:untitled1/widgets/back_button_widget.dart';

class RateOrderScreen extends StatelessWidget {
  final OrderModel order;

  const RateOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReviewsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundGrey,
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Text('rate_your_order'.tr()),
          centerTitle: true,
          backgroundColor: AppColors.backGroundGrey,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RateOrderSummaryCard(order: order),
              SizedBox(height: 24.h),
              RateReviewSection(
                titleKey: 'store_rating',
                itemType: 'store',
                itemId: order.businessId.toString(),
                onSuccess: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
