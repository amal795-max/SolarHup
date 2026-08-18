
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../../../widgets/primary_button.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import 'cart_checkout_summary.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (prev, curr) => curr is CartSuccess,
      builder: (context, state) {
        if (state is! CartSuccess) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'order_summary'.tr(),
                    style: AppStyle.h6.copyWith(color: AppColors.white),
                  ),
                  if (state.cart.orderCode.isNotEmpty)
                    Text(
                      state.cart.orderCode,
                      style: AppStyle.h6.copyWith(color: AppColors.white),
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              CartCheckoutSummary(
                order: state.cart,
                pricing: state.pricing,
                labelStyle: AppStyle.labelMedium.copyWith(color: AppColors.blue),
                valueStyle: AppStyle.labelMedium.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                ),
                totalLabelStyle: AppStyle.h6.copyWith(color: AppColors.white),
                totalValueStyle: AppStyle.h3.copyWith(color: AppColors.white),
                showItemLines: false,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: 'continue'.tr(),
                backgroundColor: AppColors.secondaryColor,
                textColor: AppColors.primaryColor,
                icon: Icons.arrow_forward,
                onPressed: () {
                  context.pushReplacement(AppRoutes.shippingInformationScreen);
                },
              ),
              SizedBox(height: 12.h),
              CustomButton(
                text: 'continue_shopping'.tr(),
                type: ButtonType.outlined,
                borderColor: AppColors.white,
                textColor: AppColors.white,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
