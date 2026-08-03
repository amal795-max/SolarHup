import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your_cart'.tr(),),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'items_count'.tr(args: ['3']),
                style: AppStyle.labelXSmall.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            const _CartList(),
            SizedBox(height: 16.h),
            const _OrderSummary(),
            SizedBox(height: 16.h),
            const _PromoCodeField(),
            SizedBox(height: 24.h),
            const _CO2OffsetBanner(),
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  const _CartList();

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'name': 'EcoFlow 400W Panel',
        'sku': 'SOL-400-EF',
        'price': 899.00,
        'quantity': 1,
        'image': 'https://placeholder.com/panel',
      },
      {
        'name': 'SmartHub Pro Inverter',
        'sku': 'INV-PRO-SH',
        'price': 1249.00,
        'quantity': 1,
        'image': 'https://placeholder.com/inverter',
      },
      {
        'name': 'MC4 Connection Kit',
        'sku': 'CAB-MC4-KIT',
        'price': 45.00,
        'quantity': 2,
        'image': 'https://placeholder.com/kit',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          Divider(height: 32.h, color: AppColors.borderColor.withOpacity(0.5)),
      itemBuilder: (context, index) {
        final item = items[index];
        return _CartItem(
          name: item['name'] as String,
          sku: item['sku'] as String,
          price: item['price'] as double,
          quantity: item['quantity'] as int,
        );
      },
    );
  }
}

class _CartItem extends StatelessWidget {
  final String name;
  final String sku;
  final double price;
  final int quantity;

  const _CartItem({
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =context.brightness;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkGray : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            color: AppColors.grey,
            size: 40.sp,
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
                      name,
                      style: AppStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: AppStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text('SKU: $sku', style: AppStyle.labelSmall),
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
                        _QtyBtn(icon: Icons.remove, onTap: () {}),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            '$quantity',
                            style: AppStyle.bodyMedium,
                          ),
                        ),
                        _QtyBtn(icon: Icons.add, onTap: () {}),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                      size: 18.sp,
                    ),
                    label: Text(
                      'remove'.tr(),
                      style: AppStyle.labelSmall.copyWith(color: AppColors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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

class _OrderSummary extends StatelessWidget {
  const _OrderSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_summary'.tr(),
            style: AppStyle.h6.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 16.h),
          _SummaryRow(label: 'subtotal'.tr(), value: '\$2,238.00'),
          _SummaryRow(label: 'shipping'.tr(), value: 'free'.tr()),
          _SummaryRow(
            label: 'estimated_tax'.tr(),
            value: '\$179.04',
            valueColor: AppColors.secondaryColor,
          ),
          Divider(color: AppColors.white.withOpacity(0.2), height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: AppStyle.h6.copyWith(color: AppColors.white),
              ),
              Text(
                '\$2,417.04',
                style: AppStyle.h3.copyWith(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          CustomButton(
            text: 'continue'.tr(),
            backgroundColor: AppColors.secondaryColor,
            textColor: AppColors.primaryColor,
            icon: Icons.arrow_forward,
            onPressed: (){
              context.push(AppRoutes.shippingInformationScreen);
            },),
          SizedBox(height: 12.h),
          CustomButton(
            text: 'continue_shopping'.tr(),
            type: ButtonType.outlined,
            borderColor: AppColors.white,
            textColor: AppColors.white,

          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyle.labelMedium.copyWith(color: AppColors.blue),
          ),
          Text(
            value,
            style: AppStyle.labelMedium.copyWith(
              color: valueColor ?? AppColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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

class _CO2OffsetBanner extends StatelessWidget {
  const _CO2OffsetBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightYellow,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.eco_outlined,
            color: AppColors.secondaryColor,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'co2_offset_msg'.tr(args: ['12,400 lbs']),
              style: AppStyle.labelSmall.copyWith(
                color: AppColors.brown,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
