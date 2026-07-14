class BlogArticleModel {
  final String id;
  final String title;
  final String excerpt;
  final String dateLabel;
  final String categoryKey;
  final String categoryLabel;
  final int imagePlaceholderColorValue;
  final String iconType;

  const BlogArticleModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.dateLabel,
    required this.categoryKey,
    required this.categoryLabel,
    required this.imagePlaceholderColorValue,
    this.iconType = 'document',
  });

  BlogArticleModel copyWith({
    String? id,
    String? title,
    String? excerpt,
    String? dateLabel,
    String? categoryKey,
    String? categoryLabel,
    int? imagePlaceholderColorValue,
    String? iconType,
  }) {
    return BlogArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      dateLabel: dateLabel ?? this.dateLabel,
      categoryKey: categoryKey ?? this.categoryKey,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      imagePlaceholderColorValue:
          imagePlaceholderColorValue ?? this.imagePlaceholderColorValue,
      iconType: iconType ?? this.iconType,
    );
  }
}

class BlogFeedModel {
  final BlogArticleModel featured;
  final List<BlogArticleModel> articles;
  final int totalPages;

  const BlogFeedModel({
    required this.featured,
    required this.articles,
    required this.totalPages,
  });
}
