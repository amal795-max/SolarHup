import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_state.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';

class ShippingInformationScreen extends StatelessWidget {
  const ShippingInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartActionSuccess) {
          DataHelper.showSnackBar(message: state.message.tr(), context: context);
          context.pushReplacement(AppRoutes.orderTrackingScreen);
        } else if (state is CartError) {
          DataHelper.showSnackBar(
            message: state.message.tr(),
            context: context,
            color: AppColors.red,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'shipping_information'.tr(),
            style: AppStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                style: AppStyle.bodyMedium.copyWith(
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              const _ShippingAddressForm(),
              SizedBox(height: 24.h),
              const _OrderSummaryCard(),
              SizedBox(height: 40.h),
            ],
          ),
        ),
        bottomNavigationBar: const _BottomActionBar(),
      ),
    );
  }
}

class _ShippingAddressForm extends StatelessWidget {
  const _ShippingAddressForm();

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkContainer : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.primaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'shipping_address'.tr(),
                style: AppStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            title: 'full_name'.tr(),
            hint: 'Johnathan Doe',
          ),
          CustomTextField(
            title: 'street_address'.tr(),
            hint: '123 Solar Way',
          ),
          CustomTextField(
            title: 'city'.tr(),
            hint: 'Palo Alto',
          ),
          Row(
            spacing: 16.w,
            children: [
              Expanded(
                child: CustomTextField(
                  title: 'building'.tr(),
                  hint: '123',
                ),
              ),
              Expanded(
                child: CustomTextField(
                  title: 'floor'.tr(),
                  hint: '2',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (prev, curr) => curr is CartSuccess || curr is CartLoading,
      builder: (context, state) {
        final order = context.read<CartCubit>().order;
        if (order == null) return const SizedBox.shrink();

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
                    style: AppStyle.labelMedium.copyWith(color: AppColors.white.withOpacity(0.7)),
                  ),
                  SizedBox(height: 16.h),
                  ...order.items.map((item) => _SummaryRow(
                        label: '${item.name} x${item.quantity}',
                        value: '${item.subtotal} \$',
                      )),
                  _SummaryRow(
                    label: 'shipping'.tr(),
                    value: 'free'.tr().toUpperCase(),
                    valueColor: AppColors.secondaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Divider(color: Colors.white.withOpacity(0.1)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'total_amount'.tr(),
                        style: AppStyle.labelMedium.copyWith(color: AppColors.white),
                      ),
                      Text(
                        '${order.totalAmount} \$',
                        style: AppStyle.h4.copyWith(color: AppColors.secondaryColor),
                      ),
                    ],
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppStyle.labelSmall.copyWith(color: AppColors.white.withOpacity(0.9)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: AppStyle.labelSmall.copyWith(
              color: valueColor ?? AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final order = context.read<CartCubit>().order;
        final isLoading = state is CartActionLoading;

        return Container(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkMode : AppColors.white,
            border: Border(top: BorderSide(color: AppColors.borderColor.withOpacity(0.2))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'grand_total'.tr().toUpperCase(),
                        style: AppStyle.labelXSmall.copyWith(color: AppColors.grey, letterSpacing: 1.2),
                      ),
                      Text(
                        '${order?.totalAmount ?? '0.00'} \$',
                        style: AppStyle.h5,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bolt, color: AppColors.brown, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'credits_earned'.tr(args: ['120']),
                          style: AppStyle.labelXSmall.copyWith(
                            color: AppColors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              if (isLoading)
                const LoadingIndicator()
              else
                CustomButton(
                  onPressed: () {
                    context.read<CartCubit>().submitCart();
                  },
                  text: 'place_order'.tr(),
                  icon: Icons.arrow_forward_rounded,
                ),
              SizedBox(height: 16.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppStyle.labelXSmall.copyWith(color: AppColors.grey),
                  children: [
                    TextSpan(text: '${'place_order_agree'.tr()} '),
                    TextSpan(
                      text: 'terms_of_service'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
