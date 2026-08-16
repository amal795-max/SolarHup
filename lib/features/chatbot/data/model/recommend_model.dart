import 'package:equatable/equatable.dart';

class RecommendResponseModel extends Equatable {
  final int conversationId;
  final String reply;
  final bool needsClarification;
  final List<RecommendedProduct> recommendedProducts;
  final List<RecommendedService> recommendedServices;

  const RecommendResponseModel({
    required this.conversationId,
    required this.reply,
    required this.needsClarification,
    required this.recommendedProducts,
    required this.recommendedServices,
  });

  factory RecommendResponseModel.fromJson(Map<String, dynamic> json) {
    return RecommendResponseModel(
      conversationId: json['conversation_id'],
      reply: json['reply'],
      needsClarification: json['needs_clarification'],
      recommendedProducts: (json['recommended_products'] as List?)
          ?.map((e) => RecommendedProduct.fromJson(e))
          .toList() ??
          [],
      recommendedServices: (json['recommended_services'] as List?)
          ?.map((e) => RecommendedService.fromJson(e))
          .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
    conversationId,
    reply,
    needsClarification,
    recommendedProducts,
    recommendedServices,
  ];
}

class RecommendedProduct extends Equatable {
  final int? id;
  final String name;
  final String description;
  final String price;
  final String? image;

  const RecommendedProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });

  factory RecommendedProduct.fromJson(Map<String, dynamic> json) {
    return RecommendedProduct(
      id: json['id']??0,
      name: json['name'],
      description: json['desc'] ?? json['name'],
      price: json['price'].toString(),
      image: json['image'],
    );
  }

  @override
  List<Object?> get props => [id, name, description, price, image];
}

class RecommendedService extends Equatable {
  final ServiceModel service;
  final String reason;

  const RecommendedService({
    required this.service,
    required this.reason,
  });

  factory RecommendedService.fromJson(Map<String, dynamic> json) {
    return RecommendedService(
      service: ServiceModel.fromJson(json['service']),
      reason: json['reason'] ?? '',
    );
  }

  @override
  List<Object?> get props => [service, reason];
}


class ServiceModel extends Equatable {
  final int id;
  final int businessId;
  final int categoryId;
  final String name;
  final String description;
  final String price;
  final int estimatedDuration;
  final String serviceType;
  final String pricingModel;
  final List<String> images;
  final bool isAvailable;
  final String status;
  final String createdAt;
  final String updatedAt;

  const ServiceModel({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.estimatedDuration,
    required this.serviceType,
    required this.pricingModel,
    required this.images,
    required this.isAvailable,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      businessId: json['business_id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price']),
      estimatedDuration: json['estimated_duration'],
      serviceType: json['service_type'],
      pricingModel: json['pricing_model'],
      images: List<String>.from(json['images'] ?? []),
      isAvailable: json['is_available'] ?? false,
      status: json['status'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    businessId,
    categoryId,
    name,
    description,
    price,
    estimatedDuration,
    serviceType,
    pricingModel,
    images,
    isAvailable,
    status,
    createdAt,
    updatedAt,
  ];
}

class ChatMessage extends Equatable {
  final int id;
  final String role;
  final String content;
  final bool hadImage;
  final String createdAt;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.hadImage,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      role: json['role'],
      content: json['content'],
      hadImage: json['had_image'] ?? false,
      createdAt: json['created_at'],
    );
  }

  @override
  List<Object?> get props => [id, role, content, hadImage, createdAt];
}
