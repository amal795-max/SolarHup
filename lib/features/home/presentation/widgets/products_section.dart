import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'product_card.dart';

class ProductsSection extends StatelessWidget {
  final String titleKey;
  final List<ProductCardData> products;
  final VoidCallback? onViewAll;
  final void Function(int index)? onProductTap;

  const ProductsSection({
    super.key,
    required this.titleKey,
    required this.products,
    this.onViewAll,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(titleKey: titleKey, onViewAll: onViewAll),
        SizedBox(height: 12.h),
        if (products.isEmpty)
          _EmptySearchResult()
        else
          SizedBox(
            height: 225.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: products.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, i) => ProductCard(
                data: products[i],
                onTap: onProductTap != null ? () => onProductTap!(i) : null,
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(Icons.search_off_rounded,
              color: AppColors.grey, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            'No results found',
            style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String titleKey;
  final VoidCallback? onViewAll;

  const _SectionHeader({required this.titleKey, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleKey.tr(),
            style: AppStyle.h6.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'home_view_all'.tr(),
              style: AppStyle.labelMedium.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
