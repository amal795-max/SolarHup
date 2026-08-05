import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_kit_bloc/store_kit_bloc.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_kit_cubit.dart';
import 'package:untitled1/features/stores/presentation/mappers/store_kit_mapper.dart';
import 'package:untitled1/features/stores/presentation/pages/store_kit_route_args.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_kit_header_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_kit_products_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_kit_search_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_kit_special_offer_section.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class StoreKitProductData {
  final String id;
  final String businessId;
  final String categoryKey;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final int imageColorValue;
  final String? imageUrl;

  const StoreKitProductData({
    required this.id,
    required this.businessId,
    required this.categoryKey,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageColorValue,
    this.imageUrl,
  });
}

class StoreKitScreen extends StatelessWidget {
  final StoreKitRouteArgs args;

  const StoreKitScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<StoreKitCubit>()..loadProducts(args.storeId),
        ),
        BlocProvider(create: (_) => StoreKitBloc()),
      ],
      child: _StoreKitView(args: args),
    );
  }
}

class _StoreKitView extends StatelessWidget {
  final StoreKitRouteArgs args;

  const _StoreKitView({required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<StoreKitCubit, StoreKitCubitState>(
          builder: (context, state) {
            return switch (state) {
              StoreKitCubitLoading() => const LoadingIndicator(),
              StoreKitCubitError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<StoreKitCubit>()
                        .loadProducts(args.storeId),
                    width: 160.w,
                  ),
                ),
              StoreKitCubitLoaded(:final products) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StoreKitHeaderSection(storeName: args.storeName),
                        SizedBox(height: 16.h),
                        const StoreKitSearchSection(),
                        SizedBox(height: 14.h),
                        StoreKitProductsSection(
                          businessId: args.storeId,
                          products: storeProductsToKitData(products),
                        ),
                        SizedBox(height: 16.h),
                        const StoreKitSpecialOfferSection(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
