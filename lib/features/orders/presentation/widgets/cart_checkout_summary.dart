import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/orders/data/models/cart_pricing_summary.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';

class CartCheckoutSummary extends StatelessWidget {
  final OrderModel order;
  final CartPricingSummary pricing;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TextStyle? totalLabelStyle;
  final TextStyle? totalValueStyle;
  final Color dividerColor;
  final bool showItemLines;

  const CartCheckoutSummary({
    super.key,
    required this.order,
    required this.pricing,
    this.labelStyle,
    this.valueStyle,
    this.totalLabelStyle,
    this.totalValueStyle,
    this.dividerColor = AppColors.white,
    this.showItemLines = true,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: r'$', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showItemLines)
          ...order.items.map(
            (item) => _SummaryRow(
              label: '${item.name} x${item.quantity}',
              value: currency.format(item.effectiveSubtotal),
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
          ),
        if (pricing.hasDiscount) ...[
          _SummaryRow(
            label: 'subtotal'.tr(),
            value: currency.format(pricing.originalTotal),
            labelStyle: labelStyle,
            valueStyle: valueStyle,
          ),
          _SummaryRow(
            label: pricing.promotionTitle?.isNotEmpty == true
                ? pricing.promotionTitle!
                : 'discount'.tr(),
            value: '-${currency.format(pricing.discountAmount)}',
            labelStyle: labelStyle,
            valueStyle: valueStyle?.copyWith(color: AppColors.secondaryColor) ??
                const TextStyle(color: AppColors.secondaryColor),
          ),
        ] else if (!showItemLines) ...[
          _SummaryRow(
            label: 'subtotal'.tr(),
            value: currency.format(pricing.originalTotal),
            labelStyle: labelStyle,
            valueStyle: valueStyle,
          ),
        ],

        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Divider(color: dividerColor.withValues(alpha: 0.2)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'total_amount'.tr(),
              style: totalLabelStyle ?? labelStyle,
            ),
            Text(
              currency.format(pricing.finalTotal),
              style: totalValueStyle ?? valueStyle,
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

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
              style: labelStyle ?? AppStyle.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: valueStyle ?? AppStyle.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
