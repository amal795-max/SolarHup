import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/enums/order_status_enum.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/refresh_loading.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_state.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../widgets/cart_item.dart';
import '../widgets/order_summary.dart';
import '../../../../widgets/primary_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    final CartCubit cubit =context.read<CartCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('your_cart'.tr(),
          style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, stateOrdersState){
              final cart = cubit.order;
              if (cart != null && cart.items.isNotEmpty) {
                return IconButton(
                  onPressed: () {
                    DataHelper().showConfirmationDialog(
                        context,
                        'delete_cart',
                        'confirm_delete_cart', () {
                      cubit.clearCart();
                      Navigator.pop(context);
                    });
                  },
                  icon: const Icon(
                      Icons.delete_sweep_outlined, color: AppColors.red),
                  tooltip: 'clear_cart'.tr(),
                );
              }
              return const SizedBox.shrink();
            },
          ),],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listenWhen: _listenWhen,
          listener: _listener,
        buildWhen: buildWhen,
        builder: _builder,
      ),
    );
  }

  bool _listenWhen(CartState previous, CartState current) {
    return current is CartActionSuccess  ;
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartActionSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
  }

  bool buildWhen(CartState previous, CartState current) {
        return current is CartActionLoading ||
        current is CartError ||
        current is CartSuccess;
  }

  Widget _builder(BuildContext context, CartState state) {
    if (state is CartError) {
      return errorWidget(
        message: state.message,
        hasButton: false,
      );
    }

    final cubit = context.read<CartCubit>();
    final isInitialLoading = state is CartLoading;
    final hasCachedData = cubit.order != null;
    final showSkeleton = showInitialLoadingSkeleton(
      isLoading: isInitialLoading,
      hasCachedData: hasCachedData,
    );

    final fakeCart = OrderModel(
      id: 0,
      orderCode: 'ORD-XXXXXXXX',
      businessId: 0,
      customerId: 0,
      status: 'pending',
      totalAmount: '0.00',
      items: List.generate(
        3,
        (index) => OrderItemModel(
          id: index,
          itemId: index,
          name: 'Loading Item Name...',
          quantity: 1,
          unitPrice: '0.00',
          subtotal: '0.00', itemType: '',
        ),
      ),
      statusEnum: OrderStatusEnum.pending,
    );

    final cartToShow = state is CartSuccess
        ? state.cart
        : (hasCachedData ? cubit.order! : fakeCart);

    if (state is CartSuccess && cartToShow.items.isEmpty && !isInitialLoading) {
      return AppRefreshIndicator(
        onRefresh: () => cubit.getCart(),
        child: ListView(
          physics: appEmptyRefreshPhysics,
          children: [
            EmptyWidget(
              icon: Icons.shopping_cart_outlined,
              title: 'cart_empty',
              subtitle: 'cart_empty_hint',
              action: CustomButton(
                text: 'empty_browse_stores'.tr(),
                onPressed: () => context.push(AppRoutes.storesScreen),
                height: 44.h,
              ),
            ),
          ],
        ),
      );
    }

    return AppRefreshIndicator(
      onRefresh: () => cubit.getCart(),
      child: Skeletonizer(
        ignoreContainers: true,
        enabled: showSkeleton,
        child: SingleChildScrollView(
          physics: appRefreshPhysics,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              _CartList(items: cartToShow.items),
              const OrderSummary(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  final List<OrderItemModel> items;

  const _CartList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          Divider(height: 16.h, color: AppColors.borderColor),
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItem(item: item);
      },
    );
  }
}
