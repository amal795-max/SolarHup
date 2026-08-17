import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/enums/order_status_enum.dart';
import 'package:untitled1/core/helper/refresh_loading.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_state.dart';
import 'package:untitled1/widgets/animation_widget.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/error_widget.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../widgets/tracking_time_line.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order_tracking'.tr()),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersError) {
            return errorWidget(message: state.message, hasButton: false);
          }
          final order = state is OrderDetailsLoaded
              ? state.order
              : (state is OrdersLoading
                    ? OrderModel(
                        id: 0,
                        orderCode: 'ORD-XXXXXXXX',
                        businessId: 0,
                        customerId: 0,
                        status: 'pending',
                        totalAmount: '0.00',
                        items: [],
                        statusEnum: OrderStatusEnum.pending,
                      )
                    : OrderModel(
                        id: 0,
                        orderCode: 'ORD-XXXXXXXX',
                        businessId: 0,
                        customerId: 0,
                        status: 'pending',
                        totalAmount: '0.00',
                        items: [],
                        statusEnum: OrderStatusEnum.pending,
                      ));
          return AppRefreshIndicator(
            onRefresh: () async {
              if (order.id != 0) {
                await context.read<OrdersCubit>().getOrderDetails(order);
              }
            },
            child: SingleChildScrollView(
              physics: appRefreshPhysics,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Skeletonizer(
                ignoreContainers: true,
                enabled: showInitialLoadingSkeleton(
                  isLoading: state is OrdersLoading,
                  hasCachedData: state is OrderDetailsLoaded,
                ),
                child: Column(
                  spacing: 16.h,
                  children: [
                    AnimationWidget(child: _OrderHeaderCard(order: order)),
                    if (order.statusEnum == OrderStatusEnum.rejected)
                      _EstimatedDeliveryBanner(order: order),
                    OrderTrackingTimeline(order: order),
                    _ShippingAddressSection(order: order),
                    _OrderSummarySection(order: order),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderHeaderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final statusEnum = order.statusEnum;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!context.brightness)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_id_label'.tr(),
            style: AppStyle.labelSmall.copyWith(color: AppColors.brown),
          ),
          Text(
            order.orderCode,
            style: AppStyle.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.tertiaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            spacing: 40.w,
            children: [
              _HeaderItem(
                label: 'status_label'.tr(),
                value: statusEnum.status.tr(),
                valueColor: statusEnum.borderAndLabelColor,
              ),
              _HeaderItem(
                label: 'items_label'.tr(),
                value: 'units_count'.tr(args: [order.items.length.toString()]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _HeaderItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyle.labelSmall.copyWith(
            color: AppColors.brown,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          value,
          style: AppStyle.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _EstimatedDeliveryBanner extends StatelessWidget {
  final OrderModel order;

  const _EstimatedDeliveryBanner({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.rejectedBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        spacing: 12.w,
        children: [
          const Icon(Icons.error_outline, color: AppColors.rejectedBorder),
          Expanded(
            child: Text(
              'order_rejected_desc'.tr(),
              style: AppStyle.labelSmall.copyWith(
                color: AppColors.rejectedBorder,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShippingAddressSection extends StatelessWidget {
  final OrderModel order;

  const _ShippingAddressSection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        spacing: 16.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'shipping_address_title'.tr(),
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            spacing: 12.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shippingFullName ?? 'N/A',
                      style: AppStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${order.shippingStreet ?? ''}, ${order.shippingCity ?? ''}\n${order.shippingFloor ?? ''}',
                      style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderSummarySection extends StatelessWidget {
  final OrderModel order;

  const _OrderSummarySection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'order_summary_label'.tr(),
            style: AppStyle.labelSmall.copyWith(
              color: AppColors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return _SummaryItem(
                    name: item.name,
                    desc: 'Qty: ${item.quantity}',
                    price: '\$${item.subtotal}',
                    imageIcon: Icons.shopping_bag_outlined,
                  );
                },
              ),
              Divider(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total_amount'.tr(),
                    style: AppStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${order.totalAmount}',
                    style: AppStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String name;
  final String desc;
  final String price;
  final IconData imageIcon;

  const _SummaryItem({
    required this.name,
    required this.desc,
    required this.price,
    required this.imageIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  desc,
                  style: AppStyle.bodySmall.copyWith(
                    color: AppColors.grey,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
