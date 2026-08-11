import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/features/orders/data/models/cart_item_model.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_state.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';
import 'package:untitled1/widgets/loader.dart';
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
            builder: (context, state) {
              final cart =cubit.order;
              if (cart != null && cart.items.isNotEmpty) {
                return IconButton(
                  onPressed: () {
                    DataHelper().showDeleteConfirmation(
                        context,
                        'delete_cart', 'confirm_delete_cart', () {
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
    return current is CartActionSuccess ;
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartActionSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
  }

  bool buildWhen(CartState previous, CartState current) {
    return current is CartLoading ||
        current is CartActionLoading ||
        current is CartError ||
        current is CartSuccess;
  }

  Widget _builder(BuildContext context, CartState state) {
    if (state is CartLoading || state is CartActionLoading) {
      return const LoadingIndicator();
    }
    else if (state is CartError) {
      return errorWidget(
          message: state.message,
          hasButton: true,
          onPressed: () => context.read<CartCubit>().getCart()

      );
    } else if (state is CartSuccess) {
      if (state.cart.items.isEmpty) {
        return const EmptyWidget();
      }
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
        child: Column(
          children: [
            _CartList(items: state.cart.items),
            OrderSummary(cart: state.cart),
            SizedBox(height: 16.h),
            const _PromoCodeField(),
            SizedBox(height: 24.h),
          ],
        ),
      );
    }
    return const SizedBox();
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
