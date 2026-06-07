import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_product_card.dart';

/// Shows the "Featured Products" header (with "View All" action) followed by
/// a vertical list of [StoreInfoProductCard] widgets.
class StoreInfoFeaturedProductsSection extends StatelessWidget {
  final List<StoreProductItem> products;

  const StoreInfoFeaturedProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ───────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'store_info_featured_products'.tr(),
                style: theme.textTheme.titleMedium,
              ),
              GestureDetector(
                onTap: () {
                  // TODO: navigate to full product listing for this store
                },
                child: Text(
                  'home_view_all'.tr(),
                  style: AppStyle.labelSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // ── Product cards ────────────────────────────────────────────────
          ...products.map(
            (product) => StoreInfoProductCard(
              product: product,
              onTap: () {
                // TODO: navigate to product detail
              },
            ),
          ),
        ],
      ),
    );
  }
}
