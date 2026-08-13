import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/image_widget.dart';

class ProductCardData {
  final String? id;
  final int? businessId;
  final String name;
  final String? category;
  final double price;
  final double? originalPrice;
  final String? badgeText;
  final Color? badgeColor;
  final String? metaText;
  final String? imageAssetPath;
  final String? imageUrl;
  final int? imagePlaceholderColorValue;
  final int? discountPercent;
  final String iconType;

  const ProductCardData({
    this.id,
    this.businessId,
    required this.name,
    this.category,
    required this.price,
    this.originalPrice,
    this.badgeText,
    this.badgeColor,
    this.metaText,
    this.imageAssetPath,
    this.imageUrl,
    this.imagePlaceholderColorValue,
    this.discountPercent,
    this.iconType = 'solar',
  });

  IconData get imageIcon {
    switch (iconType) {
      case 'inverter':
        return Icons.electrical_services;
      case 'battery':
        return Icons.battery_charging_full;
      default:
        return Icons.solar_power;
    }
  }
}

class ProductCard extends StatelessWidget {
  final ProductCardData data;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        constraints: const BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkContainer : AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _CardImage(data: data),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.category != null) ...[
                    Text(
                      data.category!,
                      style: AppStyle.labelXSmall.copyWith(
                        color: AppColors.primaryColor,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                  Text(
                    data.name,
                    style: AppStyle.labelSmall.copyWith(
                      color: isDark ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  _PriceRow(data: data, isDark: isDark),
                  if (data.metaText != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      data.metaText!,
                      style: AppStyle.labelXSmall.copyWith(
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  final ProductCardData data;
  const _CardImage({required this.data});

  bool get _hasNetworkImage =>
      data.imageUrl != null && data.imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
          child: SizedBox(
            height: 105.h,
            width: double.infinity,
            child: _hasNetworkImage
                ? ImageWidget(
                    image: data.imageUrl,
                    fit: BoxFit.cover,
                    borderRadius: 0,
                  )
                : data.imageAssetPath != null && data.imageAssetPath!.isNotEmpty
                    ? Image.asset(data.imageAssetPath!)
                    : Container(
                        color: Color(
                          data.imagePlaceholderColorValue ?? 0xFF0A2A43,
                        ),
                        child: Icon(
                          data.imageIcon,
                          color: AppColors.secondaryColor,
                          size: 40.sp,
                        ),
                      ),
          ),
        ),
        if (data.badgeText != null)
          Positioned(
            top: 8.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: data.badgeColor ?? AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                data.badgeText!,
                style: AppStyle.labelXSmall.copyWith(
                  color: data.badgeColor == AppColors.secondaryColor
                      ? AppColors.brown
                      : AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        if (data.discountPercent != null)
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                '-${data.discountPercent}%',
                style: AppStyle.labelXSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final ProductCardData data;
  final bool isDark;
  const _PriceRow({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (data.originalPrice != null) {
      return Row(
        children: [
          Text(
            '\$${data.originalPrice!.toStringAsFixed(2)}',
            style: AppStyle.labelXSmall.copyWith(
              color: AppColors.grey,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.grey,
              decorationThickness: 16,
              decorationStyle: TextDecorationStyle.solid,
            ),


          ),
          SizedBox(width: 5.w),
          Text(
            '\$${data.price.toStringAsFixed(2)}',
            style: AppStyle.bodySmall.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }
    return Text(
      '\$${data.price.toStringAsFixed(2)}',
      style: AppStyle.bodySmall.copyWith(
        color: isDark ? AppColors.white : AppColors.primaryColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
