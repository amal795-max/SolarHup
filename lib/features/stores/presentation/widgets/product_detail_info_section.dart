import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

class ProductDetailInfoSection extends StatelessWidget {
  final ProductDetailModel product;

  const ProductDetailInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final categoryLabel = product.category
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            if (categoryLabel.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  categoryLabel.toUpperCase(),
                  style: AppStyle.labelSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: product.isAvailable
                    ? AppColors.secondaryColor.withValues(alpha: 0.18)
                    : AppColors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                product.isAvailable
                    ? 'product_detail_in_stock'.tr()
                    : 'product_detail_out_of_stock'.tr(),
                style: AppStyle.labelSmall.copyWith(
                  color: product.isAvailable
                      ? AppColors.tertiaryColor
                      : AppColors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          product.title,
          style: AppStyle.h5.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          product.description,
          style: AppStyle.bodyMedium.copyWith(
            color: AppStyle.bodySmall.color,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          '\$${product.currentPrice.toStringAsFixed(2)}',
          style: AppStyle.h4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
