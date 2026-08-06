import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/store_kit_route_args.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_product_card.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/label_title_widget.dart';

/// Shows the "Featured Products" header (with "View All" action) followed by
/// a vertical list of [StoreInfoProductCard] widgets.
class StoreInfoFeaturedProductsSection extends StatelessWidget {
  final String storeId;
  final String storeName;
  final List<StoreProductItem> products;

  const StoreInfoFeaturedProductsSection({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelWidget(
            title: 'store_info_featured_products'.tr(),
            more: 'home_view_all'.tr(),
            onTap: () => context.push(
              AppRoutes.storeKitScreen,
              extra: StoreKitRouteArgs(
                storeId: storeId,
                storeName: storeName,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          if (products.isEmpty)
            EmptyWidget(
              icon: Icons.inventory_2_outlined,
              iconSize: 48,
              iconColor: AppColors.grey,
              title: 'stores_no_results'.tr(),
              subtitle: 'stores_no_results_hint'.tr(),
              padding: EdgeInsets.symmetric(vertical: 24.h),
            )
          else
            ...products.map(
              (product) => StoreInfoProductCard(
                product: product,
                onTap: () {
                  context.push(
                    AppRoutes.productDetailScreen,
                    extra: ProductDetailRouteArgs(
                      businessId: storeId,
                      productId: product.id,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
