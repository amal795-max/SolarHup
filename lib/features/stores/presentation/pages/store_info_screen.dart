import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_detail_cubit.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_info_bloc/store_info_bloc.dart';
import 'package:untitled1/features/stores/presentation/mappers/store_info_mapper.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_categories_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_details_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_expert_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_featured_products_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_header_section.dart';
import 'package:untitled1/widgets/error_widget.dart';
import 'package:untitled1/widgets/loader.dart';

// ---------------------------------------------------------------------------
// UI data_source models — kept in this file so the page and its widgets stay in sync
// ---------------------------------------------------------------------------

class StoreInfoData {
  final int id;
  final String name;
  final String description;
  final double rating;
  final String location;
  final bool isVerified;
  final int imagePlaceholderColorValue;
  final IconData iconData;
  final int iconColorValue;
  final List<StoreCategoryItem> categories;
  final List<StoreProductItem> featuredProducts;

  const StoreInfoData({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.location,
    required this.isVerified,
    required this.imagePlaceholderColorValue,
    required this.iconData,
    required this.iconColorValue,
    required this.categories,
    required this.featuredProducts,
  });
}

class StoreCategoryItem {
  final String label;
  final IconData icon;
  final int? categoryId;
  final String? category;

  const StoreCategoryItem({
    required this.label,
    required this.icon,
    this.categoryId,
    this.category,
  });
}

class StoreProductItem {
  final String id;
  final String name;
  final String categoryLabel;
  final String categoryKey;
  final int categoryId;
  final double price;
  final double? originalPrice;
  final int? discountPercent;
  final String? badgeText;
  final String? description;
  final int imagePlaceholderColorValue;
  final IconData imageIcon;
  final bool isKitProduct;

  const StoreProductItem({
    this.id = 'helios-450w',
    required this.name,
    required this.categoryLabel,
    this.categoryKey = '',
    this.categoryId = 0,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.badgeText,
    this.description,
    required this.imagePlaceholderColorValue,
    required this.imageIcon,
    this.isKitProduct = false,
  });
}

// ---------------------------------------------------------------------------
// Sample / mock data_source — used when no real data_source is provided yet
// ---------------------------------------------------------------------------

final StoreInfoData sampleStoreInfo = const StoreInfoData(
  id: 0,
  name: 'SunPeak Energy Systems',
  description:
      'Premium solar hardware solutions for sustainable living. Authorized distributor for top-tier brands.',
  rating: 4.9,
  location: 'Palo Alto, CA',
  isVerified: true,
  imagePlaceholderColorValue: 0xFF0A2A43,
  iconData: Icons.wb_sunny_rounded,
  iconColorValue: 0xFF0A2A43,
  categories: [
    StoreCategoryItem(
      label: 'Solar Panels',
      icon: Icons.solar_power_rounded,
      category: 'solar_panel',
    ),
    StoreCategoryItem(
      label: 'Batteries',
      icon: Icons.battery_charging_full_rounded,
      category: 'battery',
    ),
    StoreCategoryItem(
      label: 'Inverters',
      icon: Icons.electrical_services_rounded,
      category: 'inverter',
    ),
    StoreCategoryItem(
      label: 'EV Chargers',
      icon: Icons.ev_station_rounded,
      category: 'ev_charger',
    ),
  ],
  featuredProducts: [
    StoreProductItem(
      name: 'SunPeak Ultra 450W Monocrystalline',
      categoryLabel: 'SOLAR PANELS',
      categoryKey: 'solar_panel',
      price: 389.00,
      badgeText: 'New',
      imagePlaceholderColorValue: 0xFF1A3A5C,
      imageIcon: Icons.solar_power_rounded,
    ),
    StoreProductItem(
      name: 'LumeWall 10kWh Smart Storage',
      categoryLabel: 'BATTERIES',
      categoryKey: 'battery',
      price: 4250.00,
      originalPrice: 4900.00,
      discountPercent: 15,
      imagePlaceholderColorValue: 0xFF2D2D2D,
      imageIcon: Icons.battery_charging_full_rounded,
    ),
    StoreProductItem(
      name: 'Full Residential 5kW Solar System',
      categoryLabel: 'PREMIUM KIT',
      categoryKey: 'kit',
      price: 7899.00,
      description:
          'Complete package includes 12× 450W panels, 5kW Hybrid Inverter, and all mounting hardware.',
      imagePlaceholderColorValue: 0xFF1C3A2E,
      imageIcon: Icons.home_work_rounded,
      isKitProduct: true,
    ),
  ],
);

// ---------------------------------------------------------------------------
// StoreInfoScreen — main page
// ---------------------------------------------------------------------------

/// Entry point — loads store details from the API and provides [StoreInfoBloc]
/// for local UI state (follow, category selection).
class StoreInfoScreen extends StatelessWidget {
  final int storeId;

  const StoreInfoScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<StoreDetailCubit>()..loadStore(storeId),
        ),
        BlocProvider(create: (_) => StoreInfoBloc()),
      ],
      child: _StoreInfoView(storeId: storeId),
    );
  }
}

// ---------------------------------------------------------------------------
// Private view — reads cubit + bloc from context
// ---------------------------------------------------------------------------

class _StoreInfoView extends StatelessWidget {
  final int storeId;

  const _StoreInfoView({required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StoreDetailCubit, StoreDetailState>(
        builder: (context, state) {
          return switch (state) {
            StoreDetailLoading() => const LoadingIndicator(),
            StoreDetailError(:final message) => errorWidget(
              message: state.message ,
              hasButton: true,
                onPressed: ()=>
                context.read<StoreDetailCubit>().loadStore(storeId),
            ),
            StoreDetailLoaded(:final store, :final categories, :final products) =>
                _StoreInfoContent(
                data: storeDetailToInfoData(
                  store,
                  categories: categories,
                  products: products,
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _StoreInfoContent extends StatelessWidget {
  final StoreInfoData data;

  const _StoreInfoContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).scaffoldBackgroundColor;
    final isDark = context.brightness;
     MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: cardColor,
      body: Stack(
        children: [
          // ── Whole page scrolls together ───────────────────────────────────
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero + floating details card
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 0.3.sh,
                      width: double.infinity,
                      child: StoreInfoHeaderSection(data: data),
                    ),
                    Positioned(
                      left: 16.w,
                      right: 16.w,
                      bottom: -120.h,
                      child: Container(
                        padding: EdgeInsets.only(top: 8.h),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Theme.of(context).colorScheme.surface
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.25 : 0.12,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: StoreInfoDetailsSection(data: data),
                      ),
                    ),
                    Positioned(
                      left: 35,
                      bottom: 90.h,
                      child: _FloatingStoreLogoBadge(data: data),
                    ),
                  ],
                ),
                SizedBox(height: 0.17.sh),
                StoreInfoCategoriesSection(categories: data.categories),
                SizedBox(height: 8.h),
                BlocBuilder<StoreInfoBloc, StoreInfoState>(
                  buildWhen: (prev, curr) =>
                      prev.selectedCategoryIndex != curr.selectedCategoryIndex,
                  builder: (context, infoState) {
                    final filteredProducts = filterProductsByCategory(
                      data.featuredProducts,
                      data.categories,
                      infoState.selectedCategoryIndex,
                    );

                    return StoreInfoFeaturedProductsSection(
                      storeId: data.id,
                      storeName: data.name,
                      products: filteredProducts,
                    );
                  },
                ),
                SizedBox(height: 16.h),
                const StoreInfoExpertSection(),
                SizedBox(height: 32.h),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class _FloatingStoreLogoBadge extends StatelessWidget {
  final StoreInfoData data;

  const _FloatingStoreLogoBadge({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 65.w,
      height: 65.w,
      decoration: BoxDecoration(
        color: Color(data.iconColorValue),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.9),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.22),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(data.iconData, color: AppColors.secondaryColor, size: 28.sp),
    );
  }
}

// ---------------------------------------------------------------------------
// Back button — always white so it's legible over the hero image when expanded
// ---------------------------------------------------------------------------

