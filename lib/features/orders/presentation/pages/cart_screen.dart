import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/enums/order_status_enum.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_state.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/cart_item.dart';
import '../widgets/order_summary.dart';

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
        title: Text('your_cart'.tr()),
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

    final isLoading = state is CartLoading || state is CartActionLoading;

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

    final cartToShow = (state is CartSuccess) ? state.cart : fakeCart;

    if (state is CartSuccess && cartToShow.items.isEmpty && !isLoading) {
      return const EmptyWidget();
    }

    return Skeletonizer(
      ignoreContainers: true,
      enabled: isLoading,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            _CartList(items: cartToShow.items),
            OrderSummary(cart: cartToShow),
            SizedBox(height: 16.h),
            const _PromoCodeField(),
            SizedBox(height: 24.h),
          ],
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

class _PromoCodeField extends StatelessWidget {
  const _PromoCodeField();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomTextField(
            hasTitle: false,
            hint: 'promo_code'.tr(),
            title: '',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(child: CustomButton(text: 'apply'.tr())),
      ],
    );
  }
}
