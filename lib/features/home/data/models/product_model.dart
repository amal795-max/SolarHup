import 'dart:ui';

import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final int? businessId;
  final String name;
  final String? category;
  final double price;
  final double? originalPrice;
  final String? badgeText;
  final Color? badgeColorValue;
  final String? metaText;
  final String image;
  final String? imageUrl;
  final int? imagePlaceholderColorValue;
  final int? discountPercent;

  /// 'solar' | 'inverter' | 'battery'
  final String iconType;

  const ProductModel({
    required this.id,
    this.businessId,
    required this.name,
    this.category,
    required this.price,
    this.originalPrice,
    this.badgeText,
    this.badgeColorValue,
    this.metaText,
    this.image = '',
    this.imageUrl,
    this.imagePlaceholderColorValue,
    this.discountPercent,
    this.iconType = 'solar',
  });

  @override
  List<Object?> get props => [
        id,
        businessId,
        name,
        category,
        price,
        originalPrice,
        badgeText,
        badgeColorValue,
        metaText,
        image,
        imageUrl,
        imagePlaceholderColorValue,
        discountPercent,
        iconType,
      ];
}
