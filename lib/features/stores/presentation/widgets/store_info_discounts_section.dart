import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/store_discounted_products_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/widgets/label_title_widget.dart';

class StoreInfoDiscountsSection extends StatelessWidget {
  final int storeId;
  final String storeName;
  final List<StoreProductItem> products;

  const StoreInfoDiscountsSection({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.products,
  });

  ProductCardData _toCardData(StoreProductItem product) {
    return ProductCardData(
      id: product.id,
      businessId: storeId,
      name: product.name,
      category: product.categoryLabel,
      price: product.price,
      originalPrice: product.originalPrice,
      badgeText: product.badgeText,
      discountPercent: product.discountPercent,
      discountDescription: product.discountDescription,
      discountStartDate: product.discountStartDate,
      discountEndDate: product.discountEndDate,
      promotionAlreadyUsed: product.promotionAlreadyUsed,
      imageUrl: product.imageUrl,
      imagePlaceholderColorValue: product.imagePlaceholderColorValue,
      iconType: switch (product.imageIcon) {
        Icons.electrical_services => 'inverter',
        Icons.battery_charging_full => 'battery',
        _ => 'solar',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: LabelWidget(
              title: 'store_info_special_offers'.tr(),
              more: 'home_view_all'.tr(),
              onTap: () => context.push(
                AppRoutes.storeDiscountedProductsScreen,
                extra: StoreDiscountedProductsRouteArgs(
                  storeId: storeId,
                  storeName: storeName,
                  products: products,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 260.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: products.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  data: _toCardData(product),
                  onTap: () => context.push(
                    AppRoutes.productDetailScreen,
                    extra: ProductDetailRouteArgs(
                      businessId: storeId,
                      productId: product.id,
                    ),
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
