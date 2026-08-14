class BlogAuthorModel {
  final String name;
  final String role;
  final String dateLabel;

  const BlogAuthorModel({
    required this.name,
    required this.role,
    required this.dateLabel,
  });
}

class BlogArticleDetailModel {
  final String id;
  final String title;
  final String categoryBadge;
  final int heroColorValue;
  final String? imageUrl;
  final BlogAuthorModel author;
  final String content;

  const BlogArticleDetailModel({
    required this.id,
    required this.title,
    required this.categoryBadge,
    required this.heroColorValue,
    required this.author,
    required this.content,
    this.imageUrl,
  });
}
