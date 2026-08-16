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
import 'package:untitled1/features/services/data/models/service_request_model.dart';
import 'package:untitled1/features/services/presentation/bloc/service_requests_cubit/service_requests_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_state.dart';
import 'package:untitled1/widgets/container_style_widget.dart';
import 'package:untitled1/widgets/text_with_icon.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/error_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../../../widgets/header_section.dart';
import '../widgets/staus_order_service.dart';

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
    } else {
      context.read<ServiceRequestsCubit>().loadMyRequests();
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
          return errorWidget(message: state.message, hasButton: false);
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
                        statusEnum: OrderStatusEnum.pending,
                      ),
                    )
                  : context.read<OrdersCubit>().cachedOrders);

        if (state is OrdersLoaded && orders.isEmpty) {
          return AppRefreshIndicator(
            onRefresh: () async => context.read<OrdersCubit>().getMyOrders(),
            child: ListView(
              physics: appRefreshPhysics,
              children: const [EmptyWidget()],
            ),
          );
        }

        return AppRefreshIndicator(
          onRefresh: () async => context.read<OrdersCubit>().getMyOrders(),
          child: Skeletonizer(
            enabled: state is OrdersLoading,
            child: ListView.separated(
              physics: appRefreshPhysics,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: orders.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () {
                    context.read<OrdersCubit>().getOrderDetails(order);
                    context.push(AppRoutes.orderTrackingScreen, extra: order);
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
          ),
        );
      },
    );
  }

  Widget _buildServicesTab() {
    return BlocBuilder<ServiceRequestsCubit, ServiceRequestsState>(
      builder: (context, state) {
        if (state is ServiceRequestsError) {
          return errorWidget(message: state.message, hasButton: false);
        }

        final requests = state is ServiceRequestsLoaded
            ? state.requests
            : (state is ServiceRequestsLoading
                  ? List.generate(
                      3,
                      (index) => ServiceRequestModel(
                        id: index,
                        orderCode: 'SR-000000',
                        businessId: 0,
                        status: 'pending_approval',
                        statusEnum: OrderStatusEnum.pending,
                        totalAmount: '0.00',
                        serviceName: 'Loading service name',
                        createdAt: DateTime.now(),
                      ),
                    )
                  : context.read<ServiceRequestsCubit>().cachedRequests);

        if (state is ServiceRequestsLoaded && requests.isEmpty) {
          return AppRefreshIndicator(
            onRefresh: () async =>
                context.read<ServiceRequestsCubit>().loadMyRequests(),
            child: ListView(
              physics: appRefreshPhysics,
              children: const [EmptyWidget()],
            ),
          );
        }

        return AppRefreshIndicator(
          onRefresh: () async =>
              context.read<ServiceRequestsCubit>().loadMyRequests(),
          child: Skeletonizer(
            enabled: state is ServiceRequestsLoading,
            child: ListView.separated(
              physics: appRefreshPhysics,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: requests.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final request = requests[index];
                return GestureDetector(
                  onTap: () {
                    if (request.isCompleted) {
                      context.push(AppRoutes.rateServiceScreen, extra: request);
                      return;
                    }

                    context.read<ServiceRequestsCubit>().loadRequestDetail(
                      request.id,
                    );
                    context.push(AppRoutes.serviceRequestDetail(request.id));
                  },
                  child: _ServiceRequestCard(request: request),
                );
              },
            ),
          ),
        );
      },
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
              StatusOrderService(text: status.status.tr(), color: status),
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

class _ServiceRequestCard extends StatelessWidget {
  final ServiceRequestModel request;

  const _ServiceRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final createdAt = request.createdAt;
    final month = DateFormat('MMM').format(createdAt).toUpperCase();
    final day = DateFormat('d').format(createdAt);
    final status = request.statusEnum;
    final isActive =
        status != OrderStatusEnum.completed &&
        status != OrderStatusEnum.rejected;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.serviceName.isNotEmpty
                            ? request.serviceName
                            : request.orderCode,
                        style: AppStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    StatusOrderService(text: status.status.tr(), color: status),
                  ],
                ),
                SizedBox(height: 4.h),
                TextWithIcon(
                  title: request.orderCode,
                  icon: Icons.tag_outlined,
                  color: AppColors.grey,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total_price_label'.tr(),
                      style: AppStyle.labelSmall.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      '\$${request.totalAmount}',
                      style: AppStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (isActive) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'services_request_pending_hint'.tr(),
                    style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
