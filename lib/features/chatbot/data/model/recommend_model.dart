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
  final int id;
  final String name;
  final String description;

  const RecommendedService({
    required this.id,
    required this.name,
    required this.description,
  });

  factory RecommendedService.fromJson(Map<String, dynamic> json) {
    return RecommendedService(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, description];
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
