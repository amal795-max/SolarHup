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
import 'package:untitled1/features/orders/presentation/widgets/activity_list_card.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';
import 'package:untitled1/features/services/presentation/bloc/service_requests_cubit/service_requests_cubit.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
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
          return errorWidget(
            message: state.message, hasButton: false,
          );
        }
        final orders = state is OrdersLoaded
            ? state.orders
            : (state is OrdersLoading ? List.generate(
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
            child :Skeletonizer(
          enabled: state is OrdersLoading,
          child:  ListView.separated(
              physics: appRefreshPhysics,
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
                  child: ActivityListCard(
                    icon: Icons.shopping_bag_outlined,
                    code: order.orderCode,
                    title: order.items.isNotEmpty
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
                    context
                        .read<ServiceRequestsCubit>()
                        .loadRequestDetail(request.id);
                    context.push(
                      AppRoutes.serviceRequestDetail(request.id),
                    );
                  },
                  child: ActivityListCard(
                    icon: Icons.home_repair_service_outlined,
                    code: request.orderCode,
                    title: request.serviceName.isNotEmpty
                        ? request.serviceName
                        : request.formattedDateTime,
                    price: request.totalAmount,
                    status: OrderStatusEnum.fromString(request.status),
                  ),
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
