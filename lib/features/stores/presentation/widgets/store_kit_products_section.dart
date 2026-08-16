import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/image_url_utils.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_kit_bloc/store_kit_bloc.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/store_kit_screen.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/widgets/product_favorite_button.dart';

class StoreKitProductsSection extends StatelessWidget {
  final int businessId;
  final List<StoreCategoryItem> categories;
  final List<StoreKitProductData> products;

  const StoreKitProductsSection({
    super.key,
    required this.businessId,
    required this.categories,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreKitBloc, StoreKitState>(
      builder: (context, state) {
        final filteredProducts = _filterProducts(
          allProducts: products,
          categories: categories,
          searchQuery: state.searchQuery,
          selectedCategoryIndex: state.selectedCategoryIndex,
        );

        if (filteredProducts.isEmpty) {
          final isStoreEmpty = products.isEmpty;
          return EmptyWidget(
            icon: isStoreEmpty
                ? Icons.inventory_2_outlined
                : Icons.search_off_rounded,
            iconSize: 48,
            iconColor: AppColors.grey,
            title: 'compare_no_products_found'.tr(),
            subtitle: isStoreEmpty ? '' : 'stores_no_results_hint'.tr(),
            padding: EdgeInsets.symmetric(vertical: 24.h),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 0.62,
          ),
              itemBuilder: (context, index) => _KitProductCard(
                businessId: businessId,
                product: filteredProducts[index],
              ),
        );
      },
    );
  }

  List<StoreKitProductData> _filterProducts({
    required List<StoreKitProductData> allProducts,
    required List<StoreCategoryItem> categories,
    required String searchQuery,
    required int selectedCategoryIndex,
  }) {
    List<StoreKitProductData> categoryFiltered = allProducts;

    if (selectedCategoryIndex > 0) {
      final categoryIndex = selectedCategoryIndex - 1;
      if (categoryIndex < categories.length) {
        final selectedCategory = categories[categoryIndex];
        if (selectedCategory.categoryId != null) {
          categoryFiltered = allProducts
              .where(
                (product) => product.categoryId == selectedCategory.categoryId,
              )
              .toList();
        } else if (selectedCategory.category != null &&
            selectedCategory.category!.isNotEmpty) {
          categoryFiltered = allProducts
              .where(
                (product) => product.categoryKey == selectedCategory.category,
              )
              .toList();
        }
      }
    }

    if (searchQuery.isEmpty) return categoryFiltered;

    return categoryFiltered.where((p) {
      final priceString = p.price.toStringAsFixed(2);
      return p.name.toLowerCase().contains(searchQuery) ||
          p.categoryKey.toLowerCase().contains(searchQuery) ||
          priceString.contains(searchQuery) ||
          p.rating.toStringAsFixed(1).contains(searchQuery) ||
          p.id.toLowerCase().contains(searchQuery);
    }).toList();
  }
}

class _KitProductCard extends StatelessWidget {
  final int businessId;
  final StoreKitProductData product;

  const _KitProductCard({
    required this.businessId,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final hasImage = isDisplayableImageUrl(product.imageUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: () {
            context.push(
              AppRoutes.productDetailScreen,
              extra: ProductDetailRouteArgs(
                businessId: businessId,
                productId: product.id,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 126.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasImage)
                        ImageWidget(
                          image: product.imageUrl,
                          fit: BoxFit.cover,
                          borderRadius: 0,
                        )
                      else
                        Container(color: Color(product.imageColorValue)),
                      if (hasImage)
                        Container(
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      if (product.badgeText != null)
                        Positioned(
                          top: 6.h,
                          left: 6.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              product.badgeText!,
                              style: AppStyle.labelXSmall.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      else if (product.discountPercent != null)
                        Positioned(
                          top: 6.h,
                          left: 6.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '-${product.discountPercent}%',
                              style: AppStyle.labelXSmall.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 6.h,
                        right: 6.w,
                        child: ProductFavoriteButton(
                          productId: product.id,
                          businessId: businessId,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.rating.toStringAsFixed(1)} (${product.reviews})',
                          style: AppStyle.bodySmall.copyWith(
                            color: AppStyle.bodySmall.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        if (product.hasDiscount)
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                                  style: AppStyle.labelSmall.copyWith(
                                    color: AppColors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: AppColors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: AppStyle.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppStyle.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

