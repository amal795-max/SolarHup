import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

class ProductDetailInfoSection extends StatelessWidget {
  final ProductDetailModel product;

  const ProductDetailInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.isBestseller) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              'product_detail_bestseller'.tr(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.tertiaryColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: AppColors.secondaryColor,
              size: 18.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              '${product.rating.toStringAsFixed(1)} (${product.reviewCount} ${'product_detail_reviews_suffix'.tr()})',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          product.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          product.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${product.currentPrice.toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? theme.colorScheme.onSurface : AppColors.black,
              ),
            ),
            if (product.originalPrice != null) ...[
              SizedBox(width: 10.w),
              Text(
                '\$${product.originalPrice!.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
