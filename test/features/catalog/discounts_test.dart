import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/model/discount_list_response_model.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

void main() {
  const sampleJson = {
    'success': true,
    'data': {
      'discounts': [
        {
          'id': 1,
          'business_id': 42,
          'business_name': 'SunPeak Energy',
          'business_type': 'store',
          'title': 'Summer Sale',
          'description': 'Panel discount',
          'discount_type': 'percentage',
          'discount_value': '15',
          'discount_label': '15% OFF',
          'min_purchase_amount': '0',
          'start_date': '2026-07-01T00:00:00Z',
          'end_date': '2026-12-31T23:59:59Z',
          'categories': [],
          'products': [
            {
              'id': 7,
              'name': 'SunPeak Ultra 450W',
              'category': 'solar_panel',
            },
          ],
        },
      ],
    },
  };

  test('DiscountListResponseModel parses GET /discounts', () {
    final discounts = DiscountListResponseModel.fromJson(sampleJson).discounts;

    expect(discounts, hasLength(1));
    expect(discounts.first.businessId, 42);
    expect(discounts.first.discountValue, 15);
    expect(discounts.first.description, 'Panel discount');
    expect(discounts.first.startDate, DateTime.parse('2026-07-01T00:00:00Z'));
    expect(discounts.first.endDate, DateTime.parse('2026-12-31T23:59:59Z'));
    expect(discounts.first.products.first.id, 7);
  });

  test('flattenDiscountProducts keeps discount metadata', () {
    final discounts = DiscountListResponseModel.fromJson(sampleJson).discounts;
    final flattened = flattenDiscountProducts(discounts);

    expect(flattened.first.description, 'Panel discount');
    expect(flattened.first.startDate, isNotNull);
    expect(flattened.first.endDate, isNotNull);
  });

  test('flattenDiscountProducts deduplicates by business and product', () {
    final discounts = [
      DiscountModel.fromJson({
        'id': 1,
        'business_id': 42,
        'business_name': 'SunPeak',
        'business_type': 'store',
        'title': 'Sale',
        'description': null,
        'discount_type': 'percentage',
        'discount_value': '10',
        'discount_label': '10% OFF',
        'min_purchase_amount': '0',
        'start_date': '2026-07-01T00:00:00Z',
        'end_date': '2026-12-31T23:59:59Z',
        'categories': [],
        'products': [
          {'id': 7, 'name': 'Panel', 'category': 'solar_panel'},
        ],
      }),
      DiscountModel.fromJson({
        'id': 2,
        'business_id': 42,
        'business_name': 'SunPeak',
        'business_type': 'store',
        'title': 'Better Sale',
        'description': null,
        'discount_type': 'percentage',
        'discount_value': '20',
        'discount_label': '20% OFF',
        'min_purchase_amount': '0',
        'start_date': '2026-07-01T00:00:00Z',
        'end_date': '2026-12-31T23:59:59Z',
        'categories': [],
        'products': [
          {'id': 7, 'name': 'Panel', 'category': 'solar_panel'},
        ],
      }),
    ];

    final flattened = flattenDiscountProducts(discounts);
    expect(flattened, hasLength(1));
    expect(flattened.first.discountValue, 20);
  });

  test('applyDiscountToProductDetail applies percentage discount', () {
    const product = ProductDetailModel(
      id: 7,
      title: 'SunPeak Ultra 450W',
      description: 'Panel',
      currentPrice: 200,
      imageUrls: ['https://example.com/panel.png'],
      imagePlaceholderColorValue: 0xFF0A2A43,
      isAvailable: true,
      stockQuantity: 5,
      category: 'solar_panel',
      highlightSpecs: [],
      technicalRows: [],
    );

    final discounted = applyDiscountToProductDetail(
      product: product,
      candidate: DiscountProductCandidate(
        promotionId: 1,
        productId: '7',
        businessId: 42,
        name: 'SunPeak Ultra 450W',
        category: 'solar_panel',
        businessName: 'SunPeak',
        discountType: 'percentage',
        discountValue: 15,
        discountLabel: '15% OFF',
        description: 'Panel discount',
        startDate: DateTime.utc(2026, 7, 1),
        endDate: DateTime.utc(2026, 12, 31),
      ),
    );

    expect(discounted.currentPrice, 170);
    expect(discounted.originalPrice, 200);
    expect(discounted.discountPercent, 15);
    expect(discounted.discountDescription, 'Panel discount');
    expect(discounted.discountStartDate, isNotNull);
    expect(discounted.discountEndDate, isNotNull);
    expect(discounted.hasDiscount, isTrue);
  });
}
