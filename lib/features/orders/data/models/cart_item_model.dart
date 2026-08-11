class OrderModel {
  final int id;
  final String orderCode;
  final int businessId;
  final int customerId;
  final String? customerName;
  final String status;
  final String totalAmount;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.businessId,
    required this.customerId,
    this.customerName,
    required this.status,
    required this.totalAmount,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderCode: json['order_code'],
      businessId: json['business_id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      status: json['status'],
      totalAmount: json['total_amount'],
      items: (json['items'] as List?)
          ?.map((e) => OrderItemModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  OrderModel copyWith({
    int? id,
    String? orderCode,
    int? businessId,
    int? customerId,
    String? customerName,
    String? status,
    String? totalAmount,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
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
  });

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
    );
  }
}
