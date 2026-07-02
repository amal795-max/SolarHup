import '../models/blog_article_model.dart';

abstract class BlogRemoteDataSource {
  Future<BlogFeedModel> getBlogFeed();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  const BlogRemoteDataSourceImpl();

  static const _articles = [
    BlogArticleModel(
      id: 'blog-1',
      title: 'How to Choose the Right Solar Panel',
      excerpt:
          'Navigating the world of monocrystalline vs. polycrystalline panels can be tricky. This guide breaks down efficiency ratings, warranties, and cost-per-watt to help you make the best investment for your home.',
      dateLabel: 'October 24, 2023',
      categoryKey: 'panels',
      categoryLabel: 'Panels',
      imagePlaceholderColorValue: 0xFFE8EDF2,
      iconType: 'document',
    ),
    BlogArticleModel(
      id: 'blog-2',
      title: 'Maximizing Battery Life in Winter',
      excerpt:
          'Cold weather can impact your energy storage. Learn the best practices for maintaining your battery\'s depth of discharge during the winter months to protect your investment.',
      dateLabel: 'October 20, 2023',
      categoryKey: 'batteries',
      categoryLabel: 'Batteries',
      imagePlaceholderColorValue: 0xFFDCE4EA,
      iconType: 'battery',
    ),
    BlogArticleModel(
      id: 'blog-3',
      title: 'The Future of Micro-Inverters',
      excerpt:
          'Are micro-inverters worth the extra cost? We compare string inverters and individual panel optimization for modern residential solar setups.',
      dateLabel: 'October 15, 2023',
      categoryKey: 'inverters',
      categoryLabel: 'Inverters',
      imagePlaceholderColorValue: 0xFFE2E8EE,
      iconType: 'inverter',
    ),
    BlogArticleModel(
      id: 'blog-4',
      title: 'Understanding Net Metering Policies',
      excerpt:
          'Policy changes are shifting how homeowners get credited for excess solar production. Here is what you need to know about the latest net metering updates.',
      dateLabel: 'October 10, 2023',
      categoryKey: 'panels',
      categoryLabel: 'Panels',
      imagePlaceholderColorValue: 0xFFDBE2E9,
      iconType: 'document',
    ),
    BlogArticleModel(
      id: 'blog-5',
      title: 'Home Battery Sizing Basics',
      excerpt:
          'Choosing the right storage capacity depends on your daily usage, backup goals, and budget. This guide walks through the math in plain language.',
      dateLabel: 'October 5, 2023',
      categoryKey: 'batteries',
      categoryLabel: 'Batteries',
      imagePlaceholderColorValue: 0xFFD8E0E8,
      iconType: 'battery',
    ),
    BlogArticleModel(
      id: 'blog-6',
      title: 'Hybrid Inverters Explained',
      excerpt:
          'Hybrid systems combine grid-tie and backup capabilities in one unit. Learn when they make sense and what to ask your installer.',
      dateLabel: 'September 28, 2023',
      categoryKey: 'inverters',
      categoryLabel: 'Inverters',
      imagePlaceholderColorValue: 0xFFDDE4EB,
      iconType: 'inverter',
    ),
  ];

  @override
  Future<BlogFeedModel> getBlogFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return const BlogFeedModel(
      featured: BlogArticleModel(
        id: 'featured-1',
        title: 'Global Solar Adoption Reaches Record Highs in 2024',
        excerpt: '',
        dateLabel: '',
        categoryKey: 'panels',
        categoryLabel: 'Panels',
        imagePlaceholderColorValue: 0xFF1A3A5C,
        iconType: 'featured',
      ),
      articles: _articles,
      totalPages: 12,
    );
  }
}
