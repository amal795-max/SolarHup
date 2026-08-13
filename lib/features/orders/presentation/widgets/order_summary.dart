
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../../../widgets/primary_button.dart';
import '../../data/models/order_model.dart';

class OrderSummary extends StatelessWidget {
  final OrderModel cart;

  const OrderSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final total = cart.effectiveTotalAmount.toStringAsFixed(2);
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
              Text(
                cart.orderCode,
                style: AppStyle.h6.copyWith(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _SummaryRow(label: 'subtotal'.tr(), value: '\$$total'),
          _SummaryRow(label: 'shipping'.tr(), value: 'free'.tr()),
          Divider(color: AppColors.white.withOpacity(0.2), height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: AppStyle.h6.copyWith(color: AppColors.white),
              ),
              Text(
                '\$$total',
                style: AppStyle.h3.copyWith(color: AppColors.white),
              ),
            ],
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
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyle.labelMedium.copyWith(color: AppColors.blue),
          ),
          Text(
            value,
            style: AppStyle.labelMedium.copyWith(
              color: valueColor ?? AppColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

