import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discounted_product_model.dart';
import 'package:untitled1/features/catalog/presentation/bloc/discounted_products_cubit/discounted_products_cubit.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/widgets/app_skeletonizer.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

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
    return ProductCardData(
      id: product.productId,
      businessId: product.businessId,
      name: product.name,
      category: product.category,
      price: product.price,
      originalPrice: product.originalPrice,
      discountPercent: product.discountPercent,
      metaText: product.businessName,
      imageUrl: product.imageUrl,
      imagePlaceholderColorValue: product.imagePlaceholderColorValue,
      iconType: discountedProductToHomeProduct(product).iconType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;

    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : AppColors.backGroundGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 0),
              child: Row(
                children: [
                  const BackButtonWidget(),
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
              child: BlocBuilder<DiscountedProductsCubit, DiscountedProductsState>(
                builder: (context, state) {
                  return switch (state) {
                    DiscountedProductsLoading() => AppSkeletonizer(
                        child: GridView.builder(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.h,
                            crossAxisSpacing: 12.w,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: 6,
                          itemBuilder: (_, __) => ProductCard(
                            data: ProductCardData(
                              name: 'Loading product',
                              price: 99,
                              imagePlaceholderColorValue: 0xFF0A2A43,
                            ),
                          ),
                        ),
                      ),
                    DiscountedProductsError(:final message) => EmptyWidget(
                        icon: Icons.error_outline_rounded,
                        iconSize: 48,
                        iconColor: AppColors.red,
                        title: 'stores_error_title'.tr(),
                        subtitle: message,
                        action: CustomButton(
                          text: 'stores_retry'.tr(),
                          onPressed: () => context
                              .read<DiscountedProductsCubit>()
                              .loadDiscountedProducts(),
                          width: 160.w,
                        ),
                      ),
                    DiscountedProductsLoaded(:final products) =>
                      products.isEmpty
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12.h,
                                crossAxisSpacing: 12.w,
                                childAspectRatio: 0.72,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final card = _mapProduct(product);
                                return ProductCard(
                                  data: card,
                                  onTap: () => context.push(
                                    AppRoutes.productDetailScreen,
                                    extra: ProductDetailRouteArgs(
                                      businessId: product.businessId,
                                      productId: product.productId,
                                    ),
                                  ),
                                );
                              },
                            ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
