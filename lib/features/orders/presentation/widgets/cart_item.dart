import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../data/models/order_model.dart';
import '../bloc/cart_cubit.dart';

class CartItem extends StatelessWidget {
  final OrderItemModel item;

  const CartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(item.name, style: AppStyle.bodyMedium),
                    ),
                    Text('\$${item.unitPrice}', style: AppStyle.bodyMedium),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          _QtyBtn(
                            icon: Icons.remove,
                            onTap: () {
                              if (item.quantity > 1) {
                                context.read<CartCubit>().updateCartItem(
                                  item.itemId,
                                  item.quantity - 1,
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              '${item.quantity}',
                              style: AppStyle.bodySmall,
                            ),
                          ),
                          _QtyBtn(
                            icon: Icons.add,
                            onTap: () {
                              context.read<CartCubit>().updateCartItem(
                                item.itemId,
                                item.quantity + 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => DataHelper().showConfirmationDialog(
                        context,
                        'delete_product',
                        'delete_product_confirm',
                        () {
                          context.read<CartCubit>().deleteCartItem(item.id);
                          Navigator.pop(context);

                        }),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.red,
                      ),
                      label: Text(
                        'remove'.tr(),
                        style: AppStyle.labelSmall.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(icon, size: 16.sp, color: AppColors.grey),
      ),
    );
  }
}
