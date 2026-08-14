import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/product_compare/data/models/compare_product_model.dart';
import 'package:untitled1/features/product_compare/presentation/mappers/compare_spec_mapper.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

CompareProduct _buildProduct({
  required String category,
  required List<ProductSpecHighlight> highlights,
  List<ProductDetailDataRow> rows = const [],
  String productId = '10',
}) {
  return CompareProduct(
    businessId: 1,
    productId: productId,
    storeName: 'Sun Store',
    detail: ProductDetailModel(
      id: int.parse(productId),
      title: 'Sample',
      description: 'Desc',
      currentPrice: 100,
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
  test('buildCompareSpecRows merges specs from both products', () {
    final panel = _buildProduct(
      category: 'solar_panel',
      highlights: const [
        ProductSpecHighlight(
          labelKey: 'product_detail_efficiency',
          value: '21%',
        ),
      ],
      rows: const [
        ProductDetailDataRow(
          labelKey: 'product_detail_weight',
          value: '20 kg',
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
    );

    final rows = buildCompareSpecRows(first: panel, second: otherPanel);

    expect(rows, hasLength(2));
    expect(rows.first.leftValue, '21%');
    expect(rows.first.rightValue, '19%');
  });
}
