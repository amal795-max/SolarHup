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
