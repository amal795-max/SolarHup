import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ProductDetailBottomBar extends StatelessWidget {
  final ProductDetailModel product;

  const ProductDetailBottomBar({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '\$${product.currentPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: CustomButton(
                text: 'product_detail_add_to_cart'.tr(),
                icon: Icons.shopping_bag_outlined,
                iconLeft: true,
                backgroundColor: AppColors.secondaryColor,
                textColor: AppColors.tertiaryColor,
                fontWeight: FontWeight.w700,
                height: 48.h,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
