import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show IconData;
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

class CompareProduct extends Equatable {
  final int businessId;
  final String productId;
  final String storeName;
  final ProductDetailModel detail;

  const CompareProduct({
    required this.businessId,
    required this.productId,
    required this.storeName,
    required this.detail,
  });

  String get category => detail.category;

  @override
  List<Object?> get props => [businessId, productId, storeName, detail];
}

enum CompareAddResult {
  addedToFirstSlot,
  addedToSecondSlot,
  alreadyInCompare,
  categoryMismatch,
  bothSlotsFull,
  loadFailed,
}

class CompareProductListItem extends Equatable {
  final int businessId;
  final String productId;
  final String storeName;
  final String name;
  final double price;
  final String? imageUrl;
  final String category;
  final int imagePlaceholderColorValue;

  const CompareProductListItem({
    required this.businessId,
    required this.productId,
    required this.storeName,
    required this.name,
    required this.price,
    required this.category,
    required this.imagePlaceholderColorValue,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        businessId,
        productId,
        storeName,
        name,
        price,
        imageUrl,
        category,
        imagePlaceholderColorValue,
      ];
}

class CompareSpecRow extends Equatable {
  final String labelKey;
  final String? leftValue;
  final String? rightValue;
  final IconData? icon;

  const CompareSpecRow({
    required this.labelKey,
    this.leftValue,
    this.rightValue,
    this.icon,
  });

  @override
  List<Object?> get props => [labelKey, leftValue, rightValue, icon];
}
