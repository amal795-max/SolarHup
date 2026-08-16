import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/widgets/animation_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/label_title_widget.dart';
import 'product_card.dart';

class PromotionProductsSection extends StatelessWidget {
  final String titleKey;
  final List<ProductCardData> products;
  final VoidCallback? onViewAll;
  final void Function(int index)? onProductTap;

  const PromotionProductsSection({
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: LabelWidget(
            title: titleKey.tr(),
            more: onViewAll != null ? 'home_view_all'.tr() : '',
            onTap: onViewAll,
          ),
        ),
        SizedBox(height: 12.h),
        if (products.isEmpty)
          EmptyWidget(
            icon: Icons.search_off_rounded,
            iconSize: 18,
            iconColor: AppColors.grey,
            title: 'No results found',
            subtitle: '',
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            alignment: MainAxisAlignment.start,
          )
        else
          AnimationWidget(
            child: SizedBox(
              height: 245.h,
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
          ),
      ],
    );
  }
}
