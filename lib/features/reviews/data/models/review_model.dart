class ReviewModel {
  final int id;
  final String comment;
  final double rating;
  final String userName;
  final String? userAvatar;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.comment,
    required this.rating,
    required this.userName,
    this.userAvatar,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      ReviewModel(
        id: json['id'] ?? 0,
        comment: json['comment'] ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        userName: json['user_name'] ?? 'Anonymous',
        userAvatar: json['user_avatar'],
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
            DateTime.now(),
      );
}

class CreateReviewRequest {
  final String itemType; // store, product, workshop, service
  final String itemId;
  final double rating;
  final String comment;

  CreateReviewRequest({
    required this.itemType,
    required this.itemId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'item_type': itemType,
        'item_id': itemId,
        'rating': rating,
        'comment': comment,
      };
}
