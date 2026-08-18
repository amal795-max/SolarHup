import '../../../../core/api/api_response_utils.dart';
import '../../../../core/enums/order_status_enum.dart';

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
  final String? originalPrice;
  final String? discountAmount;
  final String? finalPrice;
  final int? appliedPromotionId;
  final String? promotionTitle;
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
    this.originalPrice,
    this.discountAmount,
    this.finalPrice,
    this.appliedPromotionId,
    this.promotionTitle,
    required this.items,
    this.createdAt,
    this.updatedAt,
    required this.statusEnum,
  });

  factory OrderModel.empty() {
    return OrderModel(
      id: 0,
      orderCode: '',
      businessId: 0,
      customerId: 0,
      status: OrderStatusEnum.pending.status,
      totalAmount: '0.00',
      originalPrice: '0.00',
      discountAmount: '0.00',
      finalPrice: '0.00',
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
      totalAmount: payload['total_amount']?.toString() ?? '0.00',
      originalPrice: payload['original_price']?.toString(),
      discountAmount: payload['discount_amount']?.toString(),
      finalPrice: payload['final_price']?.toString(),
      appliedPromotionId: payload['applied_promotion_id'] as int?,
      promotionTitle: payload['promotion_title']?.toString(),
      items:
          (payload['items'] as List?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          [],
      createdAt: payload['created_at'],
      updatedAt: payload['updated_at'],
      statusEnum: OrderStatusEnum.fromString(payload['status']),
    );
  }

  double get retailSubtotal => items.fold<double>(
        0,
        (sum, item) =>
            sum + (double.tryParse(item.unitPrice) ?? 0) * item.quantity,
      );

  bool get hasBackendDiscount {
    final discount = double.tryParse(discountAmount ?? '');
    if (discount != null && discount > 0.01) return true;

    final original = double.tryParse(originalPrice ?? '');
    final finalValue = double.tryParse(finalPrice ?? '');
    if (original != null &&
        finalValue != null &&
        finalValue < original - 0.01) {
      return true;
    }

    return appliedPromotionId != null;
  }

  double get effectiveOriginalAmount {
    if (hasBackendDiscount) {
      return double.tryParse(originalPrice ?? '') ?? retailSubtotal;
    }
    return retailSubtotal;
  }

  double get effectiveTotalAmount {
    if (hasBackendDiscount) {
      return double.tryParse(finalPrice ?? '') ??
          double.tryParse(totalAmount) ??
          0;
    }

    if (items.isEmpty) return double.tryParse(totalAmount) ?? 0;
    if (items.every((item) => !item.hasDiscount)) {
      return double.tryParse(totalAmount) ?? 0;
    }
    return items.fold<double>(0, (sum, item) => sum + item.effectiveSubtotal);
  }

  double get effectiveDiscountAmount {
    if (hasBackendDiscount) {
      final parsed = double.tryParse(discountAmount ?? '');
      if (parsed != null && parsed > 0) return parsed;
      return effectiveOriginalAmount - effectiveTotalAmount;
    }

    final discount = effectiveOriginalAmount - effectiveTotalAmount;
    return discount > 0 ? discount : 0;
  }

  bool get hasDiscountedItems =>
      hasBackendDiscount || items.any((item) => item.hasDiscount);

  bool get isCompleted => statusEnum == OrderStatusEnum.completed;

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
    String? originalPrice,
    String? discountAmount,
    String? finalPrice,
    int? appliedPromotionId,
    String? promotionTitle,
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
      originalPrice: originalPrice ?? this.originalPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      finalPrice: finalPrice ?? this.finalPrice,
      appliedPromotionId: appliedPromotionId ?? this.appliedPromotionId,
      promotionTitle: promotionTitle ?? this.promotionTitle,
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
    return {'item_type': itemType, 'item_id': itemId, 'quantity': quantity};
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
