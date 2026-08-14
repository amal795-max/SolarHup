import 'package:untitled1/core/api/api_response_utils.dart';

import '../models/blog_article_detail_model.dart';
import '../models/blog_article_model.dart';

class BlogArticleApiModel {
  final int id;
  final String title;
  final String content;
  final String? excerpt;
  final String? imageUrl;
  final DateTime createdAt;

  BlogArticleApiModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.excerpt,
    this.imageUrl,
  });

  factory BlogArticleApiModel.fromJson(Map<String, dynamic> json) {
    return BlogArticleApiModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      excerpt: json['excerpt'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  BlogArticleDetailModel toDetailModel() {
    return BlogArticleDetailModel(
      id: id.toString(),
      title: title,
      categoryBadge: 'BLOG',
      heroColorValue: _placeholderColor(id),
      imageUrl: imageUrl,
      author: BlogAuthorModel(
        name: 'SolarHub Team',
        role: 'Editorial',
        dateLabel: _formatDate(createdAt),
      ),
      content: content,
    );
  }
}

class BlogListResponseModel {
  final List<BlogArticleApiModel> articles;

  BlogListResponseModel({required this.articles});

  factory BlogListResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = unwrapApiPayload(json);
    final items = payload['articles'] as List<dynamic>? ??
        json['articles'] as List<dynamic>? ??
        const [];
    return BlogListResponseModel(
      articles: items
          .whereType<Map<String, dynamic>>()
          .map(BlogArticleApiModel.fromJson)
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
          imagePlaceholderColorValue: 0xFF1A3A5C,
        ),
        articles: [],
        totalPages: 1,
      );
    }

    return BlogFeedModel(
      featured: mapped.first,
      articles: mapped.length > 1 ? mapped.sublist(1) : const [],
      totalPages: (mapped.length / 3).ceil().clamp(1, 999),
    );
  }
}

BlogArticleModel _toArticleModel(BlogArticleApiModel article) {
  return BlogArticleModel(
    id: article.id.toString(),
    title: article.title,
    excerpt: _articleExcerpt(article),
    dateLabel: _formatDate(article.createdAt),
    imagePlaceholderColorValue: _placeholderColor(article.id),
    imageUrl: article.imageUrl,
  );
}

String _articleExcerpt(BlogArticleApiModel article) {
  final excerpt = article.excerpt?.trim();
  if (excerpt != null && excerpt.isNotEmpty) return excerpt;
  return _excerpt(article.content);
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
