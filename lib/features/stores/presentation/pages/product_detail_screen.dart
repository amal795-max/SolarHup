import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_app_bar.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_bottom_bar.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_core_specs_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_gallery_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_info_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_detail_technical_sheet_section.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

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
            ProductDetailLoading() => const LoadingIndicator(),
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
                            ProductDetailAppBar(businessId: args.businessId),
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
