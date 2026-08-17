import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/features/stores/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_app_bar.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_bottom_bar.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_core_specs_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_gallery_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_info_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_technical_sheet_section.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/app_skeletonizer.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

const ProductDetailModel _skeletonProduct = ProductDetailModel(
  id: 0,
  title: 'Product name placeholder',
  description:
      'Product description placeholder text for loading skeleton layout.',
  currentPrice: 1299.99,
  imageUrls: [],
  imagePlaceholderColorValue: 0xFFE0E0E0,
  isAvailable: true,
  stockQuantity: 12,
  category: 'solar_panel',
  highlightSpecs: [
    ProductSpecHighlight(
      labelKey: 'product_detail_max_power_output',
      value: '000 W',
      icon: Icons.bolt_rounded,
      fullWidth: true,
    ),
    ProductSpecHighlight(labelKey: 'product_detail_efficiency', value: '00%'),
    ProductSpecHighlight(labelKey: 'product_detail_warranty', value: '00 yrs'),
  ],
  technicalRows: [
    ProductDetailDataRow(labelKey: 'product_detail_weight', value: '00.0 kg'),
    ProductDetailDataRow(
      labelKey: 'product_detail_dimensions',
      value: '000 x 000 x 000',
    ),
    ProductDetailDataRow(labelKey: 'product_detail_sku', value: 'SKU-0000'),
  ],
);

class ProductDetailScreen extends StatelessWidget {
  final ProductDetailRouteArgs args;

  const ProductDetailScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductDetailBloc>()
        ..add(
          LoadProductDetailEvent(
            businessId: args.businessId,
            productId: args.productId,
          ),
        ),
      child: _ProductDetailView(args: args),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  final ProductDetailRouteArgs args;

  const _ProductDetailView({required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        return Scaffold(
          body: switch (state) {
            ProductDetailLoading() => AppSkeletonizer(
              isLoading: true,
              hasCachedData: false,
              child: _ProductDetailBody(
                businessId: args.businessId,
                product: _skeletonProduct,
                selectedImageIndex: 0,
                storeName: args.storeName,
              ),
            ),
            ProductDetailError(:final message) => SafeArea(
              child: EmptyWidget(
                icon: Icons.error_outline_rounded,
                iconSize: 48,
                iconColor: AppColors.red,
                title: 'stores_error_title'.tr(),
                subtitle: message.tr(),
                action: CustomButton(
                  text: 'stores_retry'.tr(),
                  onPressed: () => context.read<ProductDetailBloc>().add(
                    LoadProductDetailEvent(
                      businessId: args.businessId,
                      productId: args.productId,
                    ),
                  ),
                  width: 160.w,
                ),
              ),
            ),
            ProductDetailLoaded(:final product, :final selectedImageIndex) =>
              _ProductDetailBody(
                businessId: args.businessId,
                product: product,
                selectedImageIndex: selectedImageIndex,
                storeName: args.storeName,
                onRefresh: () async {
                  context.read<ProductDetailBloc>().add(
                    LoadProductDetailEvent(
                      businessId: args.businessId,
                      productId: args.productId,
                    ),
                  );
                },
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  final int businessId;
  final ProductDetailModel product;
  final int selectedImageIndex;
  final String? storeName;
  final Future<void> Function()? onRefresh;

  const _ProductDetailBody({
    required this.businessId,
    required this.product,
    required this.selectedImageIndex,
    this.storeName,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final scrollContent = SingleChildScrollView(
              physics: appRefreshPhysics,
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailAppBar(
                    businessId: businessId,
                    product: product,
                    storeName: storeName,
                  ),
                  SizedBox(height: 12.h),
                  ProductDetailGallerySection(
                    product: product,
                    selectedIndex: selectedImageIndex,
                  ),
                  SizedBox(height: 20.h),
                  ProductDetailInfoSection(product: product),
                  if (product.highlightSpecs.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    ProductDetailCoreSpecsSection(
                      specs: product.highlightSpecs,
                    ),
                  ],
                  if (product.technicalRows.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    ProductDetailTechnicalSheetSection(
                      rows: product.technicalRows,
                    ),
                  ],
                  SizedBox(height: 16.h),
                ],
              ),
            );

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: onRefresh != null
                ? AppRefreshIndicator(
                    onRefresh: onRefresh,
                    child: scrollContent,
                  )
                : scrollContent,
          ),
        ),
        ProductDetailBottomBar(product: product),
      ],
    );
  }
}
