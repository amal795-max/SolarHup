import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/presentation/widgets/staus_order_service.dart';

class RateOrderSummaryCard extends StatelessWidget {
  final OrderModel order;

  const RateOrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
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
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: titleColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'orders_tab'.tr(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'units_count'.tr(args: [order.items.length.toString()]),
                          style: theme.textTheme.labelSmall?.copyWith(
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
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.grey,
                ),
              ),
              Text(
                '\$${order.totalAmount}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
