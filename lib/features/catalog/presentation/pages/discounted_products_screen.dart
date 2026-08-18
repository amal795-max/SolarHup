import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/helper/refresh_loading.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discounted_product_model.dart';
import 'package:untitled1/features/catalog/presentation/bloc/discounted_products_cubit/discounted_products_cubit.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';

class DiscountedProductsScreen extends StatelessWidget {
  const DiscountedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DiscountedProductsCubit>()..loadDiscountedProducts(),
      child: const _DiscountedProductsView(),
    );
  }
}

class _DiscountedProductsView extends StatelessWidget {
  const _DiscountedProductsView();

  ProductCardData _mapProduct(DiscountedProductModel product) {
    final homeProduct = discountedProductToEligibleHomeProduct(
      product,
      usedPromotionIds: getIt<PromotionEligibilityService>().usedPromotionIds,
    );
    return ProductCardData(
      id: homeProduct.id,
      businessId: homeProduct.businessId,
      name: homeProduct.name,
      category: homeProduct.category,
      price: homeProduct.price,
      originalPrice: homeProduct.originalPrice,
      discountPercent: homeProduct.discountPercent,
      badgeText: homeProduct.badgeText,
      metaText: homeProduct.metaText,
      imageUrl: homeProduct.imageUrl,
      imagePlaceholderColorValue: homeProduct.imagePlaceholderColorValue,
      iconType: homeProduct.iconType,
      promotionAlreadyUsed: homeProduct.promotionAlreadyUsed,
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
                  Expanded(
                    child: Text(
                      'discounted_products_title'.tr(),
                      style: AppStyle.h6.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: Text(
                'discounted_products_subtitle'.tr(),
                style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child:
                  BlocBuilder<DiscountedProductsCubit, DiscountedProductsState>(
                    builder: (context, state) {
                      final fakeProducts = List.generate(
                        6,
                        (index) => const DiscountedProductModel(
                          productId: '',
                          businessId: 0,
                          name: 'Loading...',
                          category: '',
                          price: 0,
                          originalPrice: 0,
                          discountPercent: 0,
                          businessName: '',
                          imageUrl: '',
                          imagePlaceholderColorValue: 0xFFE0E0E0,
                          discountLabel: '',
                        ),
                      );
                      if (state is DiscountedProductsError) {
                        return errorWidget(
                          onPressed: () => context.read<DiscountedProductsCubit>().loadDiscountedProducts(),
                          message: state.message,
                          hasButton: false,
                        );
                      }

                      final isLoading = state is DiscountedProductsLoading;
                      final hasCachedData = state is DiscountedProductsLoaded;
                      final showSkeleton = showInitialLoadingSkeleton(
                        isLoading: isLoading,
                        hasCachedData: hasCachedData,
                      );

                      final products = state is DiscountedProductsLoaded
                          ? state.products
                          : fakeProducts;

                      if (state is DiscountedProductsLoaded &&
                          products.isEmpty) {
                        return AppRefreshIndicator(
                          onRefresh: () => context
                              .read<DiscountedProductsCubit>()
                              .loadDiscountedProducts(),
                          child: ListView(
                            physics: appEmptyRefreshPhysics,
                            children: [
                              EmptyWidget(
                                icon: Icons.local_offer_outlined,
                                iconSize: 48,
                                iconColor: AppColors.grey,
                                title: 'discounted_products_empty'.tr(),
                                subtitle: 'discounted_products_empty_hint'.tr(),
                                padding: EdgeInsets.symmetric(vertical: 32.h),
                              ),
                            ],
                          ),
                        );
                      }

                      return AppRefreshIndicator(
                        onRefresh: () => context
                            .read<DiscountedProductsCubit>()
                            .loadDiscountedProducts(),
                        child: Skeletonizer(
                        enabled: showSkeleton,
                        child: GridView.builder(
                          physics: appRefreshPhysics,
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12.h,
                                crossAxisSpacing: 12.w,
                                childAspectRatio: 0.72.r,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final card = _mapProduct(product);

                            return ProductCard(
                              data: card,
                              fillWidth: true,
                              onTap: showSkeleton
                                  ? null
                                  : () => context.push(
                                      AppRoutes.productDetailScreen,
                                      extra: ProductDetailRouteArgs(
                                        businessId: product.businessId,
                                        productId: product.productId,
                                      ),
                                    ),
                            );
                          },
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
