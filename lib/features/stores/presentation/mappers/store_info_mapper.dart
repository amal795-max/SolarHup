import 'package:flutter/material.dart';
import 'package:untitled1/features/stores/data/models/store_detail_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';

StoreInfoData storeDetailToInfoData(
  StoreDetailModel model, {
  List<StoreProductModel> products = const [],
}) {
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
    categories: const [],
    featuredProducts: products.map(storeProductToItem).toList(),
  );
}

StoreProductItem storeProductToItem(StoreProductModel product) {
  return StoreProductItem(
    id: product.id,
    name: product.name,
    categoryLabel: product.categoryId > 0
        ? 'Category ${product.categoryId}'
        : 'PRODUCT',
    price: product.price,
    description: product.description.isNotEmpty ? product.description : null,
    badgeText: product.isAvailable ? null : 'Unavailable',
    imagePlaceholderColorValue: product.imagePlaceholderColorValue,
    imageIcon: Icons.inventory_2_outlined,
    isKitProduct: false,
  );
}

IconData _iconForType(String type) => switch (type) {
      'sun' => Icons.wb_sunny_rounded,
      'eco' => Icons.eco_rounded,
      _ => Icons.bolt_rounded,
    };
