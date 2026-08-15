import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProductSpecHighlight extends Equatable {
  final String labelKey;
  final String value;
  final IconData? icon;
  final bool fullWidth;

  const ProductSpecHighlight({
    required this.labelKey,
    required this.value,
    this.icon,
    this.fullWidth = false,
  });

  @override
  List<Object?> get props => [labelKey, value, icon, fullWidth];
}

class ProductDetailDataRow extends Equatable {
  final String labelKey;
  final String value;

  const ProductDetailDataRow({
    required this.labelKey,
    required this.value,
  });

  @override
  List<Object?> get props => [labelKey, value];
}

class ProductDetailModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final double currentPrice;
  final double? originalPrice;
  final int? discountPercent;
  final String? discountLabel;
  final String? discountDescription;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final List<String> imageUrls;
  final int imagePlaceholderColorValue;
  final bool isAvailable;
  final int stockQuantity;
  final String category;
  final List<ProductSpecHighlight> highlightSpecs;
  final List<ProductDetailDataRow> technicalRows;

  const ProductDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.currentPrice,
    this.originalPrice,
    this.discountPercent,
    this.discountLabel,
    this.discountDescription,
    this.discountStartDate,
    this.discountEndDate,
    required this.imageUrls,
    required this.imagePlaceholderColorValue,
    required this.isAvailable,
    required this.stockQuantity,
    required this.category,
    this.highlightSpecs = const [],
    this.technicalRows = const [],
  });

  bool get hasDiscount =>
      originalPrice != null && originalPrice! > currentPrice;

  int get galleryItemCount => imageUrls.isNotEmpty ? imageUrls.length : 1;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        currentPrice,
        originalPrice,
        discountPercent,
        discountLabel,
        discountDescription,
        discountStartDate,
        discountEndDate,
        imageUrls,
        imagePlaceholderColorValue,
        isAvailable,
        stockQuantity,
        category,
        highlightSpecs,
        technicalRows,
      ];
}
