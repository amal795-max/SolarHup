class ReviewSummaryModel {
  final String itemType;
  final int itemId;
  final int reviewCount;
  final double averageRating;

  const ReviewSummaryModel({
    required this.itemType,
    required this.itemId,
    required this.reviewCount,
    required this.averageRating,
  });

  factory ReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReviewSummaryModel(
      itemType: json['item_type'] as String? ?? '',
      itemId: json['item_id'] as int? ?? 0,
      reviewCount: json['review_count'] as int? ?? 0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0,
    );
  }
}
