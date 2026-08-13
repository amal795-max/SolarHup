class ComplaintResponseModel {
  final List<ComplaintModel> complaints;

  ComplaintResponseModel({required this.complaints});

  factory ComplaintResponseModel.fromJson(Map<String, dynamic> json) {
    return ComplaintResponseModel(
      complaints: (json['complaints'] as List)
          .map((i) => ComplaintModel.fromJson(i))
          .toList(),
    );
  }
}

class ComplaintModel {
  final int id;
  final int customerId;
  final String customerPhone;
  final int businessId;
  final String businessName;
  final String subject;
  final String status;
  final List<ComplaintMessageModel> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ComplaintModel({
    required this.id,
    required this.customerId,
    required this.customerPhone,
    required this.businessId,
    required this.businessName,
    required this.subject,
    required this.status,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      customerPhone: json['customer_phone'] ?? '',
      businessId: json['business_id'] ?? 0,
      businessName: json['business_name'] ?? '',
      subject: json['subject'] ?? '',
      status: json['status'] ?? 'pending',
      messages: (json['messages'] as List?)
              ?.map((i) => ComplaintMessageModel.fromJson(i))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_phone': customerPhone,
      'business_id': businessId,
      'business_name': businessName,
      'subject': subject,
      'status': status,
      'messages': messages.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  ComplaintModel copyWith({
    int? id,
    int? customerId,
    String? customerPhone,
    int? businessId,
    String? businessName,
    String? subject,
    String? status,
    List<ComplaintMessageModel>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerPhone: customerPhone ?? this.customerPhone,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ComplaintMessageModel {
  final int id;
  final int senderId;
  final String senderRole;
  final String message;
  final DateTime createdAt;

  ComplaintMessageModel({
    required this.id,
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.createdAt,
  });

  factory ComplaintMessageModel.fromJson(Map<String, dynamic> json) {
    return ComplaintMessageModel(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      senderRole: json['sender_role'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_role': senderRole,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
  ComplaintMessageModel copyWith({
    int? id,
    int? senderId,
    String? senderRole,
    String? message,
    DateTime? createdAt,
  }) {
    return ComplaintMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderRole: senderRole ?? this.senderRole,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
