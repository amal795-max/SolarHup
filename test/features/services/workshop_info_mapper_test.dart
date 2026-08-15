import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/services/data/models/workshop_service_model.dart';
import 'package:untitled1/features/services/presentation/mappers/workshop_info_mapper.dart';

void main() {
  test('buildDiscountedWorkshopServices applies discount to matching services', () {
    const service = WorkshopServiceModel(
      id: '3',
      businessId: '7',
      categoryId: 1,
      name: 'Inverter Repair Visit',
      description: 'On-site diagnostics',
      price: 200,
      estimatedDurationMinutes: 120,
      imageUrl: null,
      isAvailable: true,
    );

    const discounts = [
      DiscountModel(
        id: 1,
        businessId: 7,
        businessName: 'Solar Fix',
        businessType: 'workshop',
        title: 'Repair Promo',
        discountType: 'fixed',
        discountValue: 50,
        discountLabel: '\$50 OFF',
        minPurchaseAmount: 0,
        description: 'Limited repair discount',
        products: [
          DiscountProductInfo(
            id: 3,
            name: 'Inverter Repair Visit',
            category: 'repair',
          ),
        ],
      ),
    ];

    final items = buildDiscountedWorkshopServices(
      services: [service],
      discounts: discounts,
      businessId: 7,
      imagePlaceholderColorValue: 0xFF0A2A43,
    );

    expect(items, hasLength(1));
    expect(items.first.price, 150);
    expect(items.first.originalPrice, 200);
    expect(items.first.badgeText, '\$50 OFF');
    expect(items.first.discountDescription, 'Limited repair discount');
    expect(items.first.hasDiscount, isTrue);
  });
}
