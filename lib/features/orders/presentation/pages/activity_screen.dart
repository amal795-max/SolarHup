import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/enums/order_status_enum.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_state.dart';
import 'package:untitled1/widgets/container_style_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';
import 'package:untitled1/widgets/text_with_icon.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../../../widgets/header_section.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    if (_selectedTab == 0) {
      context.read<OrdersCubit>().getMyOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            headerSection(
              title: 'activity_title',
              subTitle: 'activity_subtitle',
            ),
            SizedBox(height: 16.h),
            _TabSwitcher(
              selectedIndex: _selectedTab,
              onTabChanged: (index) {
                setState(() {
                  _selectedTab = index;
                });
                _fetchData();
              },
            ),
            Expanded(
              child: _selectedTab == 0
                  ? _buildOrdersTab()
                  : _buildServicesTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTab() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersError) {
          return errorWidget(
            message: state.message, hasButton: false,
          );
        }
        final orders = state is OrdersLoaded
            ? state.orders
            : (state is OrdersLoading
            ? List.generate(
                      4,
                      (index) => OrderModel(
                        id: 0,
                        orderCode: 'ORD-XXXXXXXX',
                        businessId: 0,
                        customerId: 0,
                        status: 'pending',
                        totalAmount: '0.00',
                        items: [],
                        statusEnum: OrderStatusEnum.pending
                      ),
                    )
                  :  context.read<OrdersCubit>().cachedOrders);

        if (state is OrdersLoaded && orders.isEmpty) {
          return const EmptyWidget();
        }

        return RefreshIndicator(
            onRefresh: () async => context.read<OrdersCubit>().getMyOrders(),
            child :Skeletonizer(
          enabled: state is OrdersLoading,
          child:  ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: orders.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () {
                    context.read<OrdersCubit>().getOrderDetails(order.id);
                    context.push( AppRoutes.orderTrackingScreen);
                  },
                  child: _OrderCard(
                    orderCode: order.orderCode,
                    date: order.items.isNotEmpty
                        ? 'Item Count: ${order.items.length}'
                        : 'No items',
                    price: order.totalAmount,
                    status: order.statusEnum,
                  ),
                );
              },
            ),
          ));
        },
    );
  }

  Widget _buildServicesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        spacing: 16.h,
        children: const [
          _ServiceCard(
            month: 'OCT',
            day: '12',
            title: 'System Maintenance',
            techName: 'Sarah Johnson',
            time: '09:30 AM - 11:00 AM',
            isUpcoming: true,
          ),
          _ServiceCard(
            month: 'SEP',
            day: '28',
            title: 'Battery Installation',
            techName: 'Mike Rivera',
            time: 'Completed Successfully',
            isUpcoming: false,
          ),
        ],
      ),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const _TabSwitcher({required this.selectedIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: context.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(0),
              child: _TabItem(
                title: 'orders_tab'.tr(),
                isActive: selectedIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(1),
              child: _TabItem(
                title: 'services_tab'.tr(),
                isActive: selectedIndex == 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: isActive ? context.colorScheme.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          title,
          style: AppStyle.labelMedium.copyWith(
            color: isActive ? context.colorScheme.onSurface : AppColors.grey,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderCode;
  final String date;
  final String price;
  final OrderStatusEnum status;

  const _OrderCard({
    required this.orderCode,
    required this.date,
    required this.price,
    required this.status,
  });



  @override
  Widget build(BuildContext context) {
    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              _StatusBadge(text: status.status.tr(), color: status),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            orderCode,
            style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
          ),
          Text(
            date,
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          Divider(color: AppColors.borderColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_price_label'.tr(),
                style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
              ),
              Text(
                '$price \$',
                style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final OrderStatusEnum color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.backgroundColor ,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: color.borderAndLabelColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.borderAndLabelColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String month;
  final String day;
  final String title;
  final String techName;
  final String time;
  final bool isUpcoming;

  const _ServiceCard({
    required this.month,
    required this.day,
    required this.title,
    required this.techName,
    required this.time,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return container(
      context: context,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: context.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  month,
                  style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
                ),
                Text(
                  day,
                  style: AppStyle.h4.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isUpcoming)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.amber,
                        size: 16,
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'status_past'.tr(),
                          style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                TextWithIcon(
                  title: '${'tech_label'.tr()} $techName',
                  icon: Icons.person_outline,
                  color: AppColors.grey,
                ),
                TextWithIcon(
                  title: time,
                  icon: Icons.access_time,
                  color: AppColors.grey,
                ),
                SizedBox(height: 12.h),
                if (isUpcoming)
                  Row(
                    spacing: 12.w,
                    children: [
                      Expanded(
                        child: CustomButton(text: 'reschedule_btn'.tr()),
                      ),
                      Expanded(
                        child: CustomButton(
                          text: 'details_btn'.tr(),
                          type: ButtonType.outlined,
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'download_report_btn'.tr(),
                      type: ButtonType.outlined,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
