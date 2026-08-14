class BlogArticleModel {
  final String id;
  final String title;
  final String excerpt;
  final String dateLabel;
  final int imagePlaceholderColorValue;
  final String? imageUrl;

  const BlogArticleModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.dateLabel,
    required this.imagePlaceholderColorValue,
    this.imageUrl,
  });

  BlogArticleModel copyWith({
    String? id,
    String? title,
    String? excerpt,
    String? dateLabel,
    int? imagePlaceholderColorValue,
    String? imageUrl,
  }) {
    return BlogArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      dateLabel: dateLabel ?? this.dateLabel,
      imagePlaceholderColorValue:
          imagePlaceholderColorValue ?? this.imagePlaceholderColorValue,
      imageUrl: imageUrl ?? this.imageUrl,
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
