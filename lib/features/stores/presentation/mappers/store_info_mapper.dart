import 'package:flutter/material.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/catalog/data/models/discounted_product_model.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';
import 'package:untitled1/features/stores/data/models/store_detail_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';

StoreInfoData storeDetailToInfoData(
  StoreDetailModel model, {
  List<StoreCategoryModel> categories = const [],
  List<StoreProductModel> products = const [],
  List<DiscountedProductModel> discountedProducts = const [],
  List<DiscountModel> discounts = const [],
}) {
  final categoryItems = categories.isNotEmpty
      ? apiCategoriesToItems(categories)
      : buildCategoriesFromProducts(products);
  final categoryNames = {
    for (final category in categories) category.id: category.name,
  };

  final discountItems = discountedProducts.map(discountedProductToStoreItem).toList();
  final discountByProductId = {
    for (final item in discountItems) normalizeProductId(item.id): item,
  };

  final featuredProducts = products
      .map(
        (product) {
          final base = storeProductToItem(
            product,
            categoryName: categoryNames[product.categoryId],
          );
          final discounted = discountByProductId[normalizeProductId(product.id)];
          if (discounted != null) {
            return mergeStoreItemWithDiscount(base, discounted);
          }

          final candidate = findBestDiscountForProduct(
            discounts: discounts,
            businessId: model.id,
            productId: product.id,
          );
          if (candidate != null) {
            return mergeStoreItemWithCandidate(base, candidate, product.price);
          }

          return base;
        },
      )
      .toList();

  return StoreInfoData(
    id: model.id,
    name: model.name,
    description: model.description.isNotEmpty
        ? model.description
        : model.location,
    rating: 0,
    location: model.location,
    isVerified: true,
    imagePlaceholderColorValue: model.imagePlaceholderColorValue,
    iconData: _iconForType(model.iconType),
    iconColorValue: model.imagePlaceholderColorValue,
    logoUrl: model.logoUrl,
    coverImageUrl: model.coverImageUrl,
    categories: categoriesForStore(products, categoryNames),
    discountedProducts: discountItems,
    featuredProducts: featuredProducts,
  );
}

List<StoreCategoryItem> categoriesForStore(
  List<StoreProductModel> products,
  Map<int, String> categoryNames,
) {
  final fromProducts = buildCategoriesFromProducts(products);
  return fromProducts
      .map(
        (item) => StoreCategoryItem(
          label: item.categoryId != null &&
                  categoryNames.containsKey(item.categoryId)
              ? categoryNames[item.categoryId]!
              : item.label,
          icon: item.icon,
          categoryId: item.categoryId,
          category: item.category,
        ),
      )
      .toList();
}

StoreProductItem mergeStoreItemWithDiscount(
  StoreProductItem base,
  StoreProductItem discounted,
) {
  return StoreProductItem(
    id: base.id,
    name: discounted.name.isNotEmpty ? discounted.name : base.name,
    categoryLabel: base.categoryLabel,
    categoryKey: base.categoryKey,
    categoryId: base.categoryId,
    price: discounted.price,
    originalPrice: discounted.originalPrice,
    discountPercent: discounted.discountPercent,
    badgeText: discounted.badgeText,
    description: base.description,
    discountDescription: discounted.discountDescription,
    discountStartDate: discounted.discountStartDate,
    discountEndDate: discounted.discountEndDate,
    imagePlaceholderColorValue: discounted.imagePlaceholderColorValue,
    imageIcon: base.imageIcon,
    imageUrl: discounted.imageUrl ?? base.imageUrl,
    isKitProduct: base.isKitProduct,
  );
}

StoreProductItem mergeStoreItemWithCandidate(
  StoreProductItem base,
  DiscountProductCandidate candidate,
  double retailPrice,
) {
  final pricing = computeDiscountPricing(
    retailPrice: retailPrice,
    discountType: candidate.discountType,
    discountValue: candidate.discountValue,
  );
  if (pricing.discountPercent == null && pricing.salePrice >= retailPrice) {
    return base;
  }

  return StoreProductItem(
    id: base.id,
    name: base.name,
    categoryLabel: base.categoryLabel,
    categoryKey: base.categoryKey,
    categoryId: base.categoryId,
    price: pricing.salePrice,
    originalPrice: retailPrice,
    discountPercent: pricing.discountPercent,
    badgeText:
        candidate.discountLabel.isNotEmpty ? candidate.discountLabel : null,
    description: base.description,
    discountDescription: candidate.description,
    discountStartDate: candidate.startDate,
    discountEndDate: candidate.endDate,
    imagePlaceholderColorValue: base.imagePlaceholderColorValue,
    imageIcon: base.imageIcon,
    imageUrl: base.imageUrl,
    isKitProduct: base.isKitProduct,
  );
}

StoreProductItem discountedProductToStoreItem(DiscountedProductModel product) {
  return StoreProductItem(
    id: product.productId,
    name: product.name,
    categoryLabel: product.category,
    categoryKey: product.category.toLowerCase().replaceAll(' ', '_'),
    categoryId: 0,
    price: product.price,
    originalPrice: product.originalPrice,
    discountPercent: product.discountPercent,
    badgeText: product.discountLabel.isNotEmpty ? product.discountLabel : null,
    discountDescription: product.discountDescription,
    discountStartDate: product.discountStartDate,
    discountEndDate: product.discountEndDate,
    imagePlaceholderColorValue: product.imagePlaceholderColorValue,
    imageIcon: _iconForCategory(product.category),
    imageUrl: product.imageUrl,
    isKitProduct: false,
  );
}

List<StoreCategoryItem> apiCategoriesToItems(
  List<StoreCategoryModel> categories,
) {
  return categories
      .map(
        (category) => StoreCategoryItem(
          label: category.name,
          icon: _iconForCategoryName(category.name),
          categoryId: category.id,
        ),
      )
      .toList();
}

List<StoreCategoryItem> buildCategoriesFromProducts(
  List<StoreProductModel> products,
) {
  final seen = <String>{};
  final categories = <StoreCategoryItem>[];

  for (final product in products) {
    final key = product.category.isNotEmpty
        ? product.category
        : 'category_${product.categoryId}';
    if (!seen.add(key)) continue;

    categories.add(
      StoreCategoryItem(
        label: _labelForCategory(product.category, product.categoryId),
        icon: _iconForCategory(product.category),
        categoryId: product.categoryId > 0 ? product.categoryId : null,
        category: product.category.isNotEmpty ? product.category : null,
      ),
    );
  }

  return categories;
}

List<StoreProductItem> filterProductsByCategory(
  List<StoreProductItem> products,
  List<StoreCategoryItem> categories,
  int selectedIndex,
) {
  if (categories.isEmpty || selectedIndex >= categories.length) {
    return products;
  }

  final selected = categories[selectedIndex];
  return products.where((product) {
    if (selected.categoryId != null) {
      return product.categoryId == selected.categoryId;
    }
    if (selected.category != null && selected.category!.isNotEmpty) {
      return product.categoryKey == selected.category;
    }
    return true;
  }).toList();
}

StoreProductItem storeProductToItem(
  StoreProductModel product, {
  String? categoryName,
}) {
  return StoreProductItem(
    id: product.id,
    name: product.name,
    categoryLabel: categoryName ??
        (product.category.isNotEmpty
            ? product.category.replaceAll('_', ' ').toUpperCase()
            : (product.categoryId > 0
                ? 'Category ${product.categoryId}'
                : 'PRODUCT')),
    categoryKey: product.category,
    categoryId: product.categoryId,
    price: product.price,
    description: product.description.isNotEmpty ? product.description : null,
    badgeText: product.isAvailable ? null : 'Unavailable',
    imagePlaceholderColorValue: product.imagePlaceholderColorValue,
    imageIcon: _iconForCategory(product.category),
    imageUrl: product.imageUrl,
    isKitProduct: false,
  );
}

String _labelForCategory(String category, int categoryId) {
  if (category.isEmpty) return 'Category $categoryId';
  return category
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

IconData _iconForCategoryName(String name) {
  final normalized = name.toLowerCase();
  if (normalized.contains('panel')) return Icons.solar_power_rounded;
  if (normalized.contains('batter')) {
    return Icons.battery_charging_full_rounded;
  }
  if (normalized.contains('invert')) {
    return Icons.electrical_services_rounded;
  }
  if (normalized.contains('charge controller')) {
    return Icons.tune_rounded;
  }
  if (normalized.contains('wind')) return Icons.air_rounded;
  if (normalized.contains('meter')) return Icons.speed_rounded;
  if (normalized.contains('cable') || normalized.contains('accessor')) {
    return Icons.cable_rounded;
  }
  if (normalized.contains('other')) return Icons.inventory_2_outlined;
  return Icons.category_outlined;
}

IconData _iconForCategory(String category) {
  final normalized = category.toLowerCase();
  if (normalized.contains('panel')) return Icons.solar_power_rounded;
  if (normalized.contains('batter')) {
    return Icons.battery_charging_full_rounded;
  }
  if (normalized.contains('invert')) {
    return Icons.electrical_services_rounded;
  }
  if (normalized.contains('ev') || normalized.contains('charg')) {
    return Icons.ev_station_rounded;
  }
  return Icons.inventory_2_outlined;
}

IconData _iconForType(String type) => switch (type) {
      'sun' => Icons.wb_sunny_rounded,
      'eco' => Icons.eco_rounded,
      _ => Icons.bolt_rounded,
    };
