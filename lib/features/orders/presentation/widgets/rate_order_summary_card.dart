import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/presentation/widgets/staus_order_service.dart';
import 'package:untitled1/widgets/animation_widget.dart';

import '../../../../core/routing/app_routes.dart';
import '../bloc/orders_cubit.dart';

class RateOrderSummaryCard extends StatelessWidget {
  final OrderModel order;

  const RateOrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return InkWell(
      onTap: () {
        context.read<OrdersCubit>().getOrderDetails(order.id);
        context.push(AppRoutes.orderTrackingScreen, extra: order);
      },
      child: AnimationWidget(
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              if (!context.brightness)
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundColor: AppColors.primaryColor.withValues(
                      alpha: 0.12,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.orderCode,
                                    style: AppStyle.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: titleColor,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'orders_tab'.tr(),
                                    style: AppStyle.bodySmall.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'units_count'.tr(
                                args: [order.items.length.toString()],
                              ),
                              style: AppStyle.bodyXSmall.copyWith(
                                color: AppColors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        StatusOrderService(
                          text: order.statusEnum.status.tr(),
                          color: order.statusEnum,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total_price_label'.tr(),
                    style: AppStyle.bodyXSmall.copyWith(color: AppColors.grey),
                  ),
                  Text(
                    '\$${order.totalAmount}',
                    style: AppStyle.bodySmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
