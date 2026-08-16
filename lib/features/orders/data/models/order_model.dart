import '../../../../core/enums/order_status_enum.dart';
import '../../../../core/api/api_response_utils.dart';

class OrderModel {
  final int id;
  final String orderCode;
  final int businessId;
  final int customerId;
  final String? customerName;
  final String? shippingFullName;
  final String? shippingCity;
  final String? shippingStreet;
  final String? shippingBuilding;
  final String? shippingFloor;
  final String status;
  final String totalAmount;
  final List<OrderItemModel> items;
  final String? createdAt;
  final String? updatedAt;
  final OrderStatusEnum statusEnum;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.businessId,
    required this.customerId,
    this.customerName,
    this.shippingFullName,
    this.shippingCity,
    this.shippingStreet,
    this.shippingBuilding,
    this.shippingFloor,
    required this.status,
    required this.totalAmount,
    required this.items,
    this.createdAt,
    this.updatedAt, required this.statusEnum,
  });

  factory OrderModel.empty() {
    return OrderModel(
      id: 0,
      orderCode: '',
      businessId: 0,
      customerId: 0,
      status: OrderStatusEnum.pending.status,
      totalAmount: '0.00',
      items: const [],
      statusEnum: OrderStatusEnum.pending,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final payload = unwrapOrderPayload(json);
    return OrderModel(
      id: payload['id'],
      orderCode: payload['order_code'],
      businessId: payload['business_id'],
      customerId: payload['customer_id'],
      customerName: payload['customer_name'],
      shippingFullName: payload['shipping_full_name'],
      shippingCity: payload['shipping_city'],
      shippingStreet: payload['shipping_street'],
      shippingBuilding: payload['shipping_building'],
      shippingFloor: payload['shipping_floor'],
      status: payload['status'],
      totalAmount: payload['total_amount'],
      items: (payload['items'] as List?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          [],
      createdAt: payload['created_at'],
      updatedAt: payload['updated_at'],
      statusEnum: OrderStatusEnum.fromString(payload['status']),
    );
  }

  double get effectiveTotalAmount {
    if (items.isEmpty) return double.tryParse(totalAmount) ?? 0;
    if (items.every((item) => !item.hasDiscount)) {
      return double.tryParse(totalAmount) ?? 0;
    }
    return items.fold<double>(0, (sum, item) => sum + item.effectiveSubtotal);
  }

  bool get hasDiscountedItems => items.any((item) => item.hasDiscount);

  OrderModel copyWith({
    int? id,
    String? orderCode,
    int? businessId,
    int? customerId,
    String? customerName,
    String? shippingFullName,
    String? shippingCity,
    String? shippingStreet,
    String? shippingBuilding,
    String? shippingFloor,
    String? status,
    String? totalAmount,
    List<OrderItemModel>? items,
    String? createdAt,
    String? updatedAt,
    OrderStatusEnum? statusEnum,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      shippingFullName: shippingFullName ?? this.shippingFullName,
      shippingCity: shippingCity ?? this.shippingCity,
      shippingStreet: shippingStreet ?? this.shippingStreet,
      shippingBuilding: shippingBuilding ?? this.shippingBuilding,
      shippingFloor: shippingFloor ?? this.shippingFloor,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusEnum: statusEnum ?? this.statusEnum,
    );
  }
}

class OrderItemModel {
  final int id;
  final String itemType;
  final int itemId;
  final String name;
  final String unitPrice;
  final int quantity;
  final String subtotal;
  final String? sku;
  final String? thumbnailUrl;
  final String? discountedUnitPrice;

  OrderItemModel({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    this.sku,
    this.thumbnailUrl,
    this.discountedUnitPrice,
  });

  String get effectiveUnitPrice => discountedUnitPrice ?? unitPrice;

  double get effectiveSubtotal =>
      (double.tryParse(effectiveUnitPrice) ?? 0) * quantity;

  bool get hasDiscount =>
      discountedUnitPrice != null && discountedUnitPrice != unitPrice;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      itemType: json['item_type'],
      itemId: json['item_id'],
      name: json['name'],
      unitPrice: json['unit_price'],
      quantity: json['quantity'],
      subtotal: json['subtotal'],
      sku: json['sku'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_type': itemType,
      'item_id': itemId,
      'quantity': quantity,
    };
  }

  OrderItemModel copyWith({
    int? id,
    String? itemType,
    int? itemId,
    String? name,
    String? unitPrice,
    int? quantity,
    String? subtotal,
    String? sku,
    String? thumbnailUrl,
    String? discountedUnitPrice,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      sku: sku ?? this.sku,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      discountedUnitPrice: discountedUnitPrice ?? this.discountedUnitPrice,
    );
  }
}
