import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/failure_success_message.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_state.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_cubit.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import 'package:untitled1/features/orders/presentation/widgets/cart_checkout_summary.dart';
import '../widgets/shipping_form.dart';

class ShippingInformationScreen extends StatelessWidget {
  const ShippingInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          current is CartActionSuccess &&
              current.message == cartSubmittedSuccessfully ||
          current is CartActionError,
      listener: (context, state) {
        if (state is CartActionSuccess) {
          final orderId = context.read<CartCubit>().order?.id ??
              LocalStorage().getData(key: ApiKeys.orderId);

          context.pushReplacement(AppRoutes.orderConfirmedScreen);

          if (orderId is int && orderId > 0) {
            context.read<OrdersCubit>().getOrderDetailsById(orderId);
          }

          context.read<CartCubit>().getCart();
        } else if (state is CartActionError) {
          DataHelper.showSnackBar(
            message: state.message,
            context: context,
            color: AppColors.red,
          );
        }
      },
      builder: (BuildContext context, CartState state) {
        if (state is CartActionLoading) {
          return const LoadingIndicator();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'shipping_information'.tr(),
              style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                Text(
                  'shipping_subtitle'.tr(),
                  style: AppStyle.bodyMedium.copyWith(color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                const ShippingAddressForm(),
                SizedBox(height: 24.h),
                const _OrderSummaryCard(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          bottomNavigationBar: const _BottomActionBar(),
        );
      },
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (prev, curr) =>
          curr is CartSuccess ||
          curr is CartLoading ||
          curr is CartActionError,
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final order = cubit.order;
        final pricing = cubit.pricingSummary;
        if (order == null || pricing == null) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: Icon(
                  Icons.wb_sunny_outlined,
                  color: Colors.white.withOpacity(0.05),
                  size: 80.sp,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'order_summary'.tr(),
                    style: AppStyle.labelMedium.copyWith(
                      color: AppColors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CartCheckoutSummary(
                    order: order,
                    pricing: pricing,
                    labelStyle: AppStyle.labelSmall.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                    valueStyle: AppStyle.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    totalLabelStyle: AppStyle.labelMedium.copyWith(
                      color: AppColors.white,
                    ),
                    totalValueStyle: AppStyle.h4.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (prev, curr) =>
          curr is CartSuccess ||
          curr is CartActionError ||
          curr is CartActionLoading,
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final pricing = cubit.pricingSummary;
        final formattedTotal = pricing != null
            ? '\$${pricing.finalTotal.toStringAsFixed(2)}'
            : '\$0.00';

        return Container(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkMode : AppColors.white,
            border: Border(
              top: BorderSide(color: AppColors.borderColor.withOpacity(0.2)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Text(
                        'grand_total'.tr().toUpperCase(),
                        style: AppStyle.labelSmall.copyWith(
                          color: AppColors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        formattedTotal,
                        style: AppStyle.h5,
                      ),


                ],
              ),
              SizedBox(height: 8.h),

              CustomButton(
                onPressed: () {
                  if (context.read<CartCubit>().key.currentState!.validate()) {
                    DataHelper().showConfirmationDialog(
                      context,
                      'confirm_submit_title',
                      'confirm_submit_message',
                      () {
                        Navigator.pop(context);
                        context.read<CartCubit>().submitCart();
                      },
                      confirm: 'confirm_submit_yes',
                    );
                  }
                },
                text: 'place_order'.tr(),
                icon: Icons.arrow_forward_rounded,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}
