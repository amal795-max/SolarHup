import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/core/constants/failure_success_message.dart';
import 'package:untitled1/widgets/added_to_cart_banner.dart';
import 'package:untitled1/widgets/primary_button.dart';

import '../../../orders/presentation/bloc/cart_cubit.dart';
import '../../../orders/presentation/bloc/cart_state.dart';

class ProductDetailBottomBar extends StatelessWidget {
  final ProductDetailModel product;

  const ProductDetailBottomBar({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =context.brightness;
    final barColor = isDark ? AppColors.darkContainer : AppColors.white;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: barColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'total_price_label'.tr(),
                    style: AppStyle.bodySmall,
                  ),
                  Text(
                    '\$${product.currentPrice.toStringAsFixed(2)}',
                    style: AppStyle.h6.copyWith(
                      fontWeight: FontWeight.w700,
                      color: product.hasDiscount ? AppColors.primaryColor : null,
                    ),
                  ),
                  if (product.hasDiscount)
                    Text(
                      '\$${product.originalPrice!.toStringAsFixed(2)}',
                      style: AppStyle.labelXSmall.copyWith(
                        color: AppColors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: BlocConsumer<CartCubit, CartState>(
                listener: (BuildContext context, CartState state) {
                  if (state is CartActionSuccess) {
                    if (state.message == addToCartSuccessfully) {
                      AddedToCartBanner.show(context);
                      return;
                    }
                    DataHelper.showSnackBar(
                      message: state.message,
                      context: context,
                    );
                  }
                  if (state is CartError) {
                    DataHelper.showSnackBar(
                      message: state.message,
                      context: context,
                    );
                  }
                },
                builder: (BuildContext context, CartState state) {
                  return CustomButton(
                  text: 'product_detail_add_to_cart'.tr(),
                  icon: Icons.shopping_bag_outlined,
                  iconLeft: true,
                  backgroundColor: AppColors.secondaryColor,
                  textColor: AppColors.tertiaryColor,
                  fontWeight: FontWeight.w700,
                  height: 48.h,
                  isLoading:  state is CartActionLoading,
                  onPressed: () {
                    context.read<CartCubit>().addToCart(product.id,1);
                  },
                );},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
