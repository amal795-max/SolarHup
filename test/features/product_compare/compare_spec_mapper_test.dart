import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/product_compare/data/models/compare_product_model.dart';
import 'package:untitled1/features/product_compare/presentation/mappers/compare_spec_evaluator.dart';
import 'package:untitled1/features/product_compare/presentation/mappers/compare_spec_mapper.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

CompareProduct _buildProduct({
  required String category,
  required List<ProductSpecHighlight> highlights,
  List<ProductDetailDataRow> rows = const [],
  String productId = '10',
  double price = 100,
}) {
  return CompareProduct(
    businessId: 1,
    productId: productId,
    storeName: 'Sun Store',
    detail: ProductDetailModel(
      id: int.parse(productId),
      title: 'Sample',
      description: 'Desc',
      currentPrice: price,
      imageUrls: const [],
      imagePlaceholderColorValue: 0xFF000000,
      isAvailable: true,
      stockQuantity: 1,
      category: category,
      highlightSpecs: highlights,
      technicalRows: rows,
    ),
  );
}

void main() {
  test('buildCompareSpecRows merges comparable specs and picks winner', () {
    final panel = _buildProduct(
      category: 'solar_panel',
      highlights: const [
        ProductSpecHighlight(
          labelKey: 'product_detail_efficiency',
          value: '21%',
        ),
        ProductSpecHighlight(labelKey: 'brand', value: 'SunPower'),
      ],
      rows: const [
        ProductDetailDataRow(
          labelKey: 'product_detail_weight',
          value: '20 kg',
        ),
        ProductDetailDataRow(
          labelKey: 'product_detail_sku',
          value: 'SKU-1',
        ),
      ],
    );

    final otherPanel = _buildProduct(
      category: 'solar_panel',
      productId: '11',
      highlights: const [
        ProductSpecHighlight(
          labelKey: 'product_detail_efficiency',
          value: '19%',
        ),
      ],
      rows: const [
        ProductDetailDataRow(
          labelKey: 'product_detail_weight',
          value: '22 kg',
        ),
      ],
    );

    final rows = buildCompareSpecRows(first: panel, second: otherPanel);

    expect(rows, hasLength(2));
    expect(rows[0].labelKey, 'product_detail_efficiency');
    expect(rows[0].leftValue, '21%');
    expect(rows[0].rightValue, '19%');
    expect(rows[0].winner, CompareSpecWinner.left);
    expect(rows[1].labelKey, 'product_detail_weight');
    expect(rows[1].winner, CompareSpecWinner.left);
  });

  test('evaluatePriceWinner prefers lower price', () {
    expect(
      evaluatePriceWinner(leftPrice: 90, rightPrice: 120),
      CompareSpecWinner.left,
    );
    expect(
      evaluatePriceWinner(leftPrice: 120, rightPrice: 90),
      CompareSpecWinner.right,
    );
  });
}
