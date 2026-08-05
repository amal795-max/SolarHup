import 'package:flutter/material.dart';
import 'package:untitled1/features/stores/data/models/store_detail_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';

StoreInfoData storeDetailToInfoData(
  StoreDetailModel model, {
  List<StoreProductModel> products = const [],
}) {
  final categories = buildCategoriesFromProducts(products);

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
    categories: categories,
    featuredProducts: products.map(storeProductToItem).toList(),
  );
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
    if (selected.category != null && selected.category!.isNotEmpty) {
      return product.categoryKey == selected.category;
    }
    if (selected.categoryId != null) {
      return product.categoryId == selected.categoryId;
    }
    return true;
  }).toList();
}

StoreProductItem storeProductToItem(StoreProductModel product) {
  return StoreProductItem(
    id: product.id,
    name: product.name,
    categoryLabel: product.category.isNotEmpty
        ? product.category.replaceAll('_', ' ').toUpperCase()
        : (product.categoryId > 0
            ? 'Category ${product.categoryId}'
            : 'PRODUCT'),
    categoryKey: product.category,
    categoryId: product.categoryId,
    price: product.price,
    description: product.description.isNotEmpty ? product.description : null,
    badgeText: product.isAvailable ? null : 'Unavailable',
    imagePlaceholderColorValue: product.imagePlaceholderColorValue,
    imageIcon: _iconForCategory(product.category),
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
