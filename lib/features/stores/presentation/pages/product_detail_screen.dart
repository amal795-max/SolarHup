import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/data/data_source/product_detail_remote_data_source.dart';
import 'package:untitled1/features/stores/data/repositories/product_detail_repository.dart';
import 'package:untitled1/features/stores/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_app_bar.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_bottom_bar.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_core_specs_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_gallery_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_info_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_reviews_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_technical_sheet_section.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailBloc(
        ProductDetailRepositoryImpl(
          remote: const ProductDetailRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(LoadProductDetailEvent(productId: productId)),
      child: _ProductDetailView(productId: productId),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  final String productId;

  const _ProductDetailView({required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: switch (state) {
            ProductDetailLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProductDetailError(:final message) => _ProductDetailErrorView(
                message: message,
                onRetry: () => context.read<ProductDetailBloc>().add(
                      LoadProductDetailEvent(productId: productId),
                    ),
              ),
            ProductDetailLoaded(
              :final product,
              :final selectedImageIndex,
            ) =>
              Column(
                children: [
                  Expanded(
                    child: SafeArea(
                      bottom: false,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ProductDetailAppBar(),
                            SizedBox(height: 12.h),
                            ProductDetailGallerySection(
                              product: product,
                              selectedIndex: selectedImageIndex,
                            ),
                            SizedBox(height: 20.h),
                            ProductDetailInfoSection(product: product),
                            SizedBox(height: 24.h),
                            ProductDetailCoreSpecsSection(
                              specs: product.coreSpecs,
                            ),
                            SizedBox(height: 24.h),
                            ProductDetailTechnicalSheetSection(
                              data: product.technicalData,
                            ),
                            SizedBox(height: 24.h),
                            ProductDetailReviewsSection(
                              reviews: product.reviews,
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ProductDetailBottomBar(product: product),
                ],
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _ProductDetailErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProductDetailErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: AppColors.red,
            ),
            SizedBox(height: 16.h),
            Text(
              'stores_error_title'.tr(),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              text: 'stores_retry'.tr(),
              onPressed: onRetry,
              width: 160.w,
            ),
          ],
        ),
      ),
    );
  }
}
