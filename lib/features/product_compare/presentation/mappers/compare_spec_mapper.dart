import 'package:flutter/material.dart' show IconData;
import 'package:untitled1/features/product_compare/data/models/compare_product_model.dart';
import 'package:untitled1/features/product_compare/presentation/mappers/compare_spec_evaluator.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

List<CompareSpecRow> buildCompareSpecRows({
  CompareProduct? first,
  CompareProduct? second,
}) {
  final orderedKeys = <String>[];
  final leftValues = <String, String>{};
  final rightValues = <String, String>{};
  final icons = <String, IconData?>{};

  void absorb(ProductDetailModel? detail, {required bool isLeft}) {
    if (detail == null) return;

    for (final spec in detail.highlightSpecs) {
      if (!isComparableSpecKey(spec.labelKey)) continue;
      orderedKeys.addIfAbsent(spec.labelKey);
      if (isLeft) {
        leftValues[spec.labelKey] = spec.value;
      } else {
        rightValues[spec.labelKey] = spec.value;
      }
      icons.putIfAbsent(spec.labelKey, () => spec.icon);
    }

    for (final row in detail.technicalRows) {
      if (!isComparableSpecKey(row.labelKey)) continue;
      orderedKeys.addIfAbsent(row.labelKey);
      if (isLeft) {
        leftValues[row.labelKey] = row.value;
      } else {
        rightValues[row.labelKey] = row.value;
      }
    }
  }

  absorb(first?.detail, isLeft: true);
  absorb(second?.detail, isLeft: false);

  return orderedKeys
      .map((key) {
        final leftValue = leftValues[key];
        final rightValue = rightValues[key];
        if (leftValue == null && rightValue == null) return null;

        return CompareSpecRow(
          labelKey: key,
          leftValue: leftValue,
          rightValue: rightValue,
          icon: icons[key],
          winner: evaluateSpecWinner(
            labelKey: key,
            leftValue: leftValue,
            rightValue: rightValue,
          ),
        );
      })
      .whereType<CompareSpecRow>()
      .toList(growable: false);
}

String formatCompareCategoryLabel(String category) {
  if (category.isEmpty) return 'Product';
  return category
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

extension _CompareListExt on List<String> {
  void addIfAbsent(String value) {
    if (!contains(value)) add(value);
  }
}
