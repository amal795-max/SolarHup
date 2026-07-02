import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_kit_bloc/store_kit_bloc.dart';
import 'package:untitled1/features/stores/presentation/pages/store_kit_screen.dart';
import 'package:untitled1/widgets/empty_widget.dart';

class StoreKitProductsSection extends StatelessWidget {
  final List<StoreKitProductData> products;

  const StoreKitProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreKitBloc, StoreKitState>(
      builder: (context, state) {
        final filteredProducts = _filterProducts(
          allProducts: products,
          searchQuery: state.searchQuery,
          selectedCategoryIndex: state.selectedCategoryIndex,
        );

        if (filteredProducts.isEmpty) {
          return EmptyWidget(
            icon: Icons.search_off_rounded,
            iconSize: 48,
            iconColor: AppColors.grey,
            title: 'stores_no_results'.tr(),
            subtitle: 'stores_no_results_hint'.tr(),
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
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) => _KitProductCard(
            product: filteredProducts[index],
            isFavorite: state.isFavorite(filteredProducts[index].id),
          ),
        );
      },
    );
  }

  List<StoreKitProductData> _filterProducts({
    required List<StoreKitProductData> allProducts,
    required String searchQuery,
    required int selectedCategoryIndex,
  }) {
    final categoryFiltered = switch (selectedCategoryIndex) {
      1 => allProducts.where((p) => p.categoryKey == 'panels').toList(),
      2 => allProducts.where((p) => p.categoryKey == 'batteries').toList(),
      _ => allProducts,
    };

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
  final StoreKitProductData product;
  final bool isFavorite;

  const _KitProductCard({
    required this.product,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: () {
            context.push(AppRoutes.productDetailScreen, extra: product.id);
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
                      Container(
                        color: Color(product.imageColorValue),
                      ),
                      Positioned(
                        top: 4.h,
                        right: 4.w,
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 28.w,
                              minHeight: 28.w,
                            ),
                            iconSize: 14.sp,
                            onPressed: () {
                              context.read<StoreKitBloc>().add(
                                    ToggleStoreKitFavoriteEvent(product.id),
                                  );
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? AppColors.red
                                  : Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                            ),
                          ),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            Material(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                              clipBehavior: Clip.antiAlias,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: 34.w,
                                  minHeight: 34.w,
                                ),
                                iconSize: 18.sp,
                                onPressed: () =>
                                    context.push(AppRoutes.cartScreen),
                                icon: const Icon(
                                  Icons.shopping_cart_checkout_rounded,
                                  color: AppColors.tertiaryColor,
                                ),
                              ),
                            ),
                          ],
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
