import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/core/enums/order_status_enum.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/data/repositories/orders_repository.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';

class _MockOrdersRepository extends Mock implements OrdersRepository {}

void main() {
  late _MockOrdersRepository ordersRepository;
  late PromotionEligibilityService service;

  setUp(() {
    ordersRepository = _MockOrdersRepository();
    service = PromotionEligibilityService(ordersRepository);
  });

  test('markUsed excludes promotion from eligibility checks', () {
    service.markUsed(3);

    expect(service.isEligible(3), isFalse);
    expect(service.isEligible(4), isTrue);
    expect(service.usedPromotionIds, {3});
  });

  test('syncFromOrderList collects applied promotion ids', () {
    service.syncFromOrderList([
      OrderModel(
        id: 1,
        orderCode: 'ORD-1',
        businessId: 1,
        customerId: 1,
        status: 'completed',
        totalAmount: '100.00',
        appliedPromotionId: 3,
        items: const [],
        statusEnum: OrderStatusEnum.completed,
      ),
    ]);

    expect(service.usedPromotionIds, {3});
  });

  test('findBestDiscountForProduct skips used promotions', () {
    final discounts = [
      DiscountModel.fromJson({
        'id': 3,
        'business_id': 42,
        'business_name': 'SunPeak',
        'business_type': 'store',
        'title': 'Summer Sale',
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

    final candidate = findBestDiscountForProduct(
      discounts: discounts,
      businessId: 42,
      productId: '7',
      excludedPromotionIds: {3},
    );

    expect(candidate, isNull);
  });

  test('applyEligiblePromotionPricingToCart keeps retail price when promo used', () {
    final discounts = [
      DiscountModel.fromJson({
        'id': 3,
        'business_id': 42,
        'business_name': 'SunPeak',
        'business_type': 'store',
        'title': 'Summer Sale',
        'description': null,
        'discount_type': 'percentage',
        'discount_value': '20',
        'discount_label': '20% OFF',
        'min_purchase_amount': '0',
        'start_date': null,
        'end_date': null,
        'categories': [],
        'products': [
          {'id': 7, 'name': 'Panel', 'category': 'solar_panel'},
        ],
      }),
    ];

    final cart = OrderModel(
      id: 10,
      orderCode: 'ORD-10',
      businessId: 42,
      customerId: 1,
      status: 'pending',
      totalAmount: '500.00',
      items: [
        OrderItemModel(
          id: 1,
          itemType: 'product',
          itemId: 7,
          name: 'Panel',
          unitPrice: '500.00',
          quantity: 1,
          subtotal: '500.00',
        ),
      ],
      statusEnum: OrderStatusEnum.pending,
    );

    final priced = applyEligiblePromotionPricingToCart(
      cart,
      discounts,
      usedPromotionIds: {3},
    );

    expect(priced.items.single.discountedUnitPrice, isNull);
    expect(priced.items.single.effectiveUnitPrice, '500.00');
  });

  test('ensureSynced loads used promotions from order history', () async {
    when(() => ordersRepository.getMyOrders()).thenAnswer(
      (_) async => Right([
        OrderModel(
          id: 2,
          orderCode: 'ORD-2',
          businessId: 1,
          customerId: 1,
          status: 'completed',
          totalAmount: '400.00',
          appliedPromotionId: 8,
          items: const [],
          statusEnum: OrderStatusEnum.completed,
        ),
      ]),
    );

    await service.ensureSynced();

    expect(service.usedPromotionIds, {8});
    verify(() => ordersRepository.getMyOrders()).called(1);
  });
}
