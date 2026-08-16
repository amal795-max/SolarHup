import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/home/data/models/product_model.dart';
import 'package:untitled1/features/home/presentation/bloc/top_selling_products_cubit/top_selling_products_cubit.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';

class TopSellingProductsScreen extends StatelessWidget {
  const TopSellingProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TopSellingProductsCubit>()..loadTopSellingProducts(),
      child: const _TopSellingProductsView(),
    );
  }
}

class _TopSellingProductsView extends StatelessWidget {
  const _TopSellingProductsView();

  ProductCardData _mapProduct(ProductModel product) {
    return ProductCardData(
      id: product.id,
      businessId: product.businessId,
      name: product.name,
      category: product.category,
      price: product.price,
      originalPrice: product.originalPrice,
      discountPercent: product.discountPercent,
      badgeText: product.badgeText,
      metaText: product.metaText,
      imageAssetPath: product.image.isNotEmpty ? product.image : null,
      imageUrl: product.imageUrl,
      imagePlaceholderColorValue: product.imagePlaceholderColorValue,
      iconType: product.iconType,
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
              child: Text(
                'top_selling_products_title'.tr(),
                style: AppStyle.h6.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: Text(
                'top_selling_products_subtitle'.tr(),
                style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: BlocBuilder<TopSellingProductsCubit, TopSellingProductsState>(
                builder: (context, state) {
                  final fakeProducts = List.generate(
                    6,
                    (index) => const ProductModel(
                      id: '',
                      name: 'Loading...',
                      price: 0,
                    ),
                  );

                  if (state is TopSellingProductsError) {
                    return errorWidget(
                      onPressed: () => context
                          .read<TopSellingProductsCubit>()
                          .loadTopSellingProducts(),
                      message: state.message,
                      hasButton: true,
                    );
                  }

                  final isLoading = state is TopSellingProductsLoading;
                  final products = state is TopSellingProductsLoaded
                      ? state.products
                      : fakeProducts;

                  if (state is TopSellingProductsLoaded && products.isEmpty) {
                    return AppRefreshIndicator(
                      onRefresh: () => context
                          .read<TopSellingProductsCubit>()
                          .loadTopSellingProducts(),
                      child: ListView(
                        physics: appRefreshPhysics,
                        children: [
                          EmptyWidget(
                            icon: Icons.trending_up_rounded,
                            iconSize: 48,
                            iconColor: AppColors.grey,
                            title: 'top_selling_products_empty'.tr(),
                            subtitle: 'top_selling_products_empty_hint'.tr(),
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                          ),
                        ],
                      ),
                    );
                  }

                  return AppRefreshIndicator(
                    onRefresh: () => context
                        .read<TopSellingProductsCubit>()
                        .loadTopSellingProducts(),
                    child: Skeletonizer(
                      enabled: isLoading,
                      child: GridView.builder(
                        physics: appRefreshPhysics,
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            onTap: isLoading
                                ? null
                                : () => context.push(
                                      AppRoutes.productDetailScreen,
                                      extra: ProductDetailRouteArgs(
                                        businessId: product.businessId!,
                                        productId: product.id,
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
