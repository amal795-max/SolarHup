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
