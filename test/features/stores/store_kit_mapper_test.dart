import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/stores/presentation/mappers/store_kit_mapper.dart';

void main() {
  test('storeProductsToKitData applies discount pricing to matching products', () {
    const product = StoreProductModel(
      id: '7',
      businessId: '42',
      categoryId: 1,
      name: 'SunPeak Ultra 450W',
      description: 'Panel',
      price: 200,
      quantity: 5,
      category: 'solar_panel',
      imageUrl: null,
      isAvailable: true,
      imagePlaceholderColorValue: 0xFF0A2A43,
    );

    const discounts = [
      DiscountModel(
        id: 1,
        businessId: 42,
        businessName: 'SunPeak',
        businessType: 'store',
        title: 'Summer Sale',
        discountType: 'percentage',
        discountValue: 15,
        discountLabel: '15% OFF',
        minPurchaseAmount: 0,
        products: [
          DiscountProductInfo(id: 7, name: 'SunPeak Ultra 450W', category: 'solar_panel'),
        ],
      ),
    ];

    final kitProducts = storeProductsToKitData(
      [product],
      businessId: 42,
      discounts: discounts,
    );

    expect(kitProducts, hasLength(1));
    expect(kitProducts.first.price, 170);
    expect(kitProducts.first.originalPrice, 200);
    expect(kitProducts.first.discountPercent, 15);
    expect(kitProducts.first.hasDiscount, isTrue);
  });

  test('normalizeProductId matches numeric ids with different formatting', () {
    expect(normalizeProductId('7'), '7');
    expect(normalizeProductId(' 7 '), '7');
    expect(normalizeProductId('007'), '7');
  });
}
