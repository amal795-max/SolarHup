import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/stores/data/model/store_products_response_model.dart';
import 'package:untitled1/features/stores/presentation/mappers/store_info_mapper.dart';

void main() {
  const sampleJson = {
    'products': [
      {
        'id': 7,
        'business_id': 42,
        'category_id': 3,
        'name': 'SunPeak Ultra 450W',
        'description': 'High efficiency monocrystalline panel.',
        'price': '389.00',
        'quantity': 12,
        'images': ['https://example.com/panel.png'],
        'is_available': true,
        'created_at': '2026-07-30T16:16:54.142Z',
        'updated_at': '2026-07-30T16:16:54.142Z',
      },
    ],
  };

  test('StoreProductsResponseModel parses GET /stores/{id}/products', () {
    final products =
        StoreProductsResponseModel.fromJson(sampleJson).toStoreProductModels();

    expect(products, hasLength(1));
    expect(products.first.id, '7');
    expect(products.first.name, 'SunPeak Ultra 450W');
    expect(products.first.price, 389);
    expect(products.first.imageUrl, 'https://example.com/panel.png');
  });

  test('storeProductToItem maps API product into existing store product card UI', () {
    final product =
        StoreProductsResponseModel.fromJson(sampleJson).toStoreProductModels().first;
    final ui = storeProductToItem(product);

    expect(ui.id, '7');
    expect(ui.name, 'SunPeak Ultra 450W');
    expect(ui.price, 389);
    expect(ui.categoryLabel, 'Category 3');
    expect(ui.description, 'High efficiency monocrystalline panel.');
    expect(ui.imageUrl, 'https://example.com/panel.png');
  });
}
