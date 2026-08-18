import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/store_discounted_products_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/widgets/empty_widget.dart';

class StoreDiscountedProductsScreen extends StatelessWidget {
  final StoreDiscountedProductsRouteArgs args;

  const StoreDiscountedProductsScreen({super.key, required this.args});

  ProductCardData _toCardData(StoreProductItem product) {
    return ProductCardData(
      id: product.id,
      businessId: args.storeId,
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
    final isDark = context.brightness;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.backGroundGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'store_info_special_offers'.tr(),
                          style: AppStyle.h6.copyWith(fontWeight: FontWeight.w800),
                        ),
                        if (args.storeName.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            args.storeName,
                            style: AppStyle.bodySmall.copyWith(
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
            SizedBox(height: 12.h),
            Expanded(
              child: args.products.isEmpty
                  ? EmptyWidget(
                      icon: Icons.local_offer_outlined,
                      iconSize: 48,
                      iconColor: AppColors.grey,
                      title: 'discounted_products_empty'.tr(),
                      subtitle: 'discounted_products_empty_hint'.tr(),
                      padding: EdgeInsets.symmetric(vertical: 32.h),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.72.r,
                      ),
                      itemCount: args.products.length,
                      itemBuilder: (context, index) {
                        final product = args.products[index];
                        return ProductCard(
                          data: _toCardData(product),
                          fillWidth: true,
                          onTap: () => context.push(
                            AppRoutes.productDetailScreen,
                            extra: ProductDetailRouteArgs(
                              businessId: args.storeId,
                              productId: product.id,
                              storeName: args.storeName,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
