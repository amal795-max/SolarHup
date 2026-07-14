import '../models/blog_article_detail_model.dart';
import '../models/blog_article_model.dart';

class BlogArticleApiModel {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;

  BlogArticleApiModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory BlogArticleApiModel.fromJson(Map<String, dynamic> json) {
    return BlogArticleApiModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  BlogArticleDetailModel toDetailModel() {
    return BlogArticleDetailModel(
      id: id.toString(),
      title: title,
      categoryBadge: 'BLOG',
      heroColorValue: _placeholderColor(id),
      author: BlogAuthorModel(
        name: 'SolarHub Team',
        role: 'Editorial',
        dateLabel: _formatDate(createdAt),
      ),
      contentBlocks: [
        BlogContentBlockModel(
          type: BlogContentBlockType.paragraph,
          text: content,
        ),
      ],
      relatedArticles: const [],
    );
  }
}

class BlogListResponseModel {
  final List<BlogArticleApiModel> articles;

  BlogListResponseModel({required this.articles});

  factory BlogListResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['articles'] as List<dynamic>? ?? [];
    return BlogListResponseModel(
      articles: items
          .map((item) => BlogArticleApiModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  BlogFeedModel toFeedModel() {
    final mapped = articles.map(_toArticleModel).toList();

    if (mapped.isEmpty) {
      return const BlogFeedModel(
        featured: BlogArticleModel(
          id: '0',
          title: '',
          excerpt: '',
          dateLabel: '',
          categoryKey: 'panels',
          categoryLabel: 'Panels',
          imagePlaceholderColorValue: 0xFF1A3A5C,
          iconType: 'featured',
        ),
        articles: [],
        totalPages: 1,
      );
    }

    return BlogFeedModel(
      featured: mapped.first.copyWith(iconType: 'featured'),
      articles: mapped.length > 1 ? mapped.sublist(1) : const [],
      totalPages: (mapped.length / 3).ceil().clamp(1, 999),
    );
  }
}

BlogArticleModel _toArticleModel(BlogArticleApiModel article) {
  return BlogArticleModel(
    id: article.id.toString(),
    title: article.title,
    excerpt: _excerpt(article.content),
    dateLabel: _formatDate(article.createdAt),
    categoryKey: 'panels',
    categoryLabel: 'Panels',
    imagePlaceholderColorValue: _placeholderColor(article.id),
    iconType: 'document',
  );
}

String _excerpt(String content) {
  final normalized = content.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (normalized.length <= 160) return normalized;
  return '${normalized.substring(0, 157)}...';
}

String _formatDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

int _placeholderColor(int id) {
  const palette = [
    0xFFE8EDF2,
    0xFFDCE4EA,
    0xFFE2E8EE,
    0xFFDBE2E9,
    0xFFD8E0E8,
    0xFFDDE4EB,
    0xFF1A3A5C,
  ];
  return palette[id.abs() % palette.length];
}
