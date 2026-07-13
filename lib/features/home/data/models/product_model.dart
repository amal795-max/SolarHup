import 'dart:ui';

import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String? category;
  final double price;
  final double? originalPrice;
  final String? badgeText;
  final Color? badgeColorValue;
  final String? metaText;
  final String image;
  final int? discountPercent;

  /// 'solar' | 'inverter'
  final String iconType;

  const ProductModel({
    required this.id,
    required this.name,
    this.category,
    required this.price,
    this.originalPrice,
    this.badgeText,
    this.badgeColorValue,
    this.metaText,
    required this.image,
    this.discountPercent,
    this.iconType = 'solar',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        price,
        originalPrice,
        badgeText,
        badgeColorValue,
        metaText,
        image,
        discountPercent,
        iconType,
      ];
}
