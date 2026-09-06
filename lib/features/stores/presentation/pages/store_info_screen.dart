import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/helper/image_url_utils.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_detail_cubit.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_info_bloc/store_info_bloc.dart';
import 'package:untitled1/features/stores/presentation/mappers/store_info_mapper.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_categories_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_details_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_discounts_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_featured_products_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_info_header_section.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/app_skeletonizer.dart';
import 'package:untitled1/widgets/error_widget.dart';
import 'package:untitled1/widgets/image_widget.dart';

import '../../../../core/theme/app_style.dart';

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
  final String? logoUrl;
  final String? coverImageUrl;
  final double? latitude;
  final double? longitude;
  final List<StoreCategoryItem> categories;
  final List<StoreProductItem> featuredProducts;
  final List<StoreProductItem> discountedProducts;

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
    this.logoUrl,
    this.coverImageUrl,
    this.latitude,
    this.longitude,
    required this.categories,
    required this.featuredProducts,
    this.discountedProducts = const [],
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
  final String? description;
  final int? discountPercent;
  final String? badgeText;
  final String? discountDescription;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final int imagePlaceholderColorValue;
  final IconData imageIcon;
  final String? imageUrl;
  final bool isKitProduct;
  final bool promotionAlreadyUsed;

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
    this.discountDescription,
    this.discountStartDate,
    this.discountEndDate,
    required this.imagePlaceholderColorValue,
    required this.imageIcon,
    this.imageUrl,
    this.isKitProduct = false,
    this.promotionAlreadyUsed = false,
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
/// for local UI state (category selection).
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
            StoreDetailLoading() => AppSkeletonizer(
              isLoading: true,
              hasCachedData: false,
              child: _StoreInfoContent(data: sampleStoreInfo),
            ),
            StoreDetailError(:final message) => errorWidget(
              message: message,
              hasButton: true,
              onPressed: () =>
                  context.read<StoreDetailCubit>().loadStore(storeId),
            ),
            StoreDetailLoaded(
              :final store,
              :final categories,
              :final products,
              :final discountedProducts,
              :final discounts,
            ) =>
              _StoreInfoContent(
                storeId: storeId,
                data: storeDetailToInfoData(
                  store,
                  categories: categories,
                  products: products,
                  discountedProducts: discountedProducts,
                  discounts: discounts,
                  usedPromotionIds:
                      getIt<PromotionEligibilityService>().usedPromotionIds,
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _StoreInfoContent extends StatefulWidget {
  final StoreInfoData data;
  final int? storeId;

  const _StoreInfoContent({required this.data, this.storeId});

  @override
  State<_StoreInfoContent> createState() => _StoreInfoContentState();
}

class _StoreInfoContentState extends State<_StoreInfoContent> {
  final GlobalKey _mapKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  void _scrollToMap() {
    final context = _mapKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).scaffoldBackgroundColor;
    final isDark = context.brightness;

    final scrollContent = SingleChildScrollView(
      controller: _scrollController,
      physics: appRefreshPhysics,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero + floating details card — sized so taps register on the card
          SizedBox(
            height: 0.3.sh + 140.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 0.3.sh,
                  child: StoreInfoHeaderSection(data: widget.data),
                ),
                Positioned(
                  top: 0.18.sh,
                  left: 16.w,
                  right: 16.w,
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
                    child: StoreInfoDetailsSection(
                      data: widget.data,
                      onMapTap: _scrollToMap,
                    ),
                  ),
                ),
                Positioned(
                  top: 0.2.sh - 50.h,
                  left: 35.w,
                  child: _FloatingStoreLogoBadge(data: widget.data),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          StoreInfoCategoriesSection(categories: widget.data.categories),
          if (widget.data.categories.isEmpty) SizedBox(height: 32.h),
          StoreInfoDiscountsSection(
            storeId: widget.data.id,
            storeName: widget.data.name,
            products: widget.data.discountedProducts,
          ),
          SizedBox(height: 8.h),
          BlocBuilder<StoreInfoBloc, StoreInfoState>(
            buildWhen: (prev, curr) =>
                prev.selectedCategoryIndex != curr.selectedCategoryIndex,
            builder: (context, infoState) {
              final filteredProducts = filterProductsByCategory(
                widget.data.featuredProducts,
                widget.data.categories,
                infoState.selectedCategoryIndex,
              );

              return StoreInfoFeaturedProductsSection(
                storeId: widget.data.id,
                storeName: widget.data.name,
                products: filteredProducts,
              );
            },
          ),
          if (widget.data.latitude != null && widget.data.longitude != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'store_location'.tr(),
                    style: AppStyle.h6.copyWith(fontWeight: FontWeight.bold),
                  ),

                ],
              ),
            ),
            Container(
              key: _mapKey,
              child: _StoreInfoMapSection(
                latitude: widget.data.latitude!,
                longitude: widget.data.longitude!,
              ),
            ),
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: cardColor,
      body: widget.storeId != null
          ? AppRefreshIndicator(
              onRefresh: () =>
                  context.read<StoreDetailCubit>().loadStore(widget.storeId!),
              child: scrollContent,
            )
          : scrollContent,
    );
  }
}

class _FloatingStoreLogoBadge extends StatelessWidget {
  final StoreInfoData data;

  const _FloatingStoreLogoBadge({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasLogo = isDisplayableImageUrl(data.logoUrl);

    return Container(
      width: 65.w,
      height: 65.w,
      decoration: BoxDecoration(
        color: hasLogo ? AppColors.white : Color(data.iconColorValue),
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
      clipBehavior: Clip.antiAlias,
      child: hasLogo
          ? ImageWidget(
              image: data.logoUrl,
              width: 65.w,
              height: 65.w,
              borderRadius: 14,
              fit: BoxFit.cover,
            )
          : Icon(data.iconData, color: AppColors.secondaryColor, size: 28.sp),
    );
  }
}

class _StoreInfoMapSection extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _StoreInfoMapSection({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            initialZoom: 18,

          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
              subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
              userAgentPackageName: 'com.example.untitled1',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 45.w,
                  height: 45.w,
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.red,
                    size: 35,
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}

// ---------------------------------------------------------------------------
// Back button — always white so it's legible over the hero image when expanded
// ---------------------------------------------------------------------------
