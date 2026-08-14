import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/blog/data/model/blog_list_response_model.dart';

void main() {
  test('BlogArticleApiModel parses image_url and excerpt', () {
    final article = BlogArticleApiModel.fromJson({
      'id': 7,
      'title': 'Solar Basics',
      'content': 'Long article body text here.',
      'excerpt': 'Short summary',
      'image_url': 'https://cdn.example.com/blog/solar.jpg',
      'created_at': '2026-03-15T10:00:00.000Z',
    });

    expect(article.imageUrl, 'https://cdn.example.com/blog/solar.jpg');
    expect(article.excerpt, 'Short summary');
  });

  test('BlogListResponseModel maps articles with image_url to feed model', () {
    final response = BlogListResponseModel.fromJson({
      'data': {
        'articles': [
          {
            'id': 1,
            'title': 'First Post',
            'content': 'Content one',
            'excerpt': 'Excerpt one',
            'image_url': 'https://cdn.example.com/1.jpg',
            'created_at': '2026-01-01T08:00:00.000Z',
          },
          {
            'id': 2,
            'title': 'Second Post',
            'content': 'Content two',
            'created_at': '2026-01-02T08:00:00.000Z',
          },
        ],
      },
    });

    final feed = response.toFeedModel();

    expect(feed.featured.imageUrl, 'https://cdn.example.com/1.jpg');
    expect(feed.featured.excerpt, 'Excerpt one');
    expect(feed.articles.single.imageUrl, isNull);
  });

  test('BlogArticleApiModel toDetailModel passes image_url and content', () {
    final detail = BlogArticleApiModel.fromJson({
      'id': 3,
      'title': 'Detail Post',
      'content': 'Full content',
      'image_url': 'https://cdn.example.com/detail.jpg',
      'created_at': '2026-02-01T12:00:00.000Z',
    }).toDetailModel();

    expect(detail.imageUrl, 'https://cdn.example.com/detail.jpg');
    expect(detail.title, 'Detail Post');
    expect(detail.content, 'Full content');
  });
}
