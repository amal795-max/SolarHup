import '../models/blog_article_detail_model.dart';
import '../models/blog_article_model.dart';

abstract class BlogDetailRemoteDataSource {
  Future<BlogArticleDetailModel> getArticleDetail(String articleId);
}

class BlogDetailRemoteDataSourceImpl implements BlogDetailRemoteDataSource {
  const BlogDetailRemoteDataSourceImpl();

  static const _winterArticle = BlogArticleDetailModel(
    id: 'blog-2',
    title: 'Optimizing Your Battery Storage for Winter',
    categoryBadge: 'ENERGY EFFICIENCY',
    heroColorValue: 0xFF1A3A5C,
    author: BlogAuthorModel(
      name: 'Sarah Jenkins',
      role: 'Senior Energy Analyst',
      dateLabel: 'Oct 24, 2023',
    ),
    sponsoredProduct: BlogSponsoredProductModel(
      storeName: 'Sun Power',
      title: '10kWh Lithium Battery Storage',
      subtitle: 'Wall-Mounted LiFePO4',
      price: 4650.00,
    ),
    contentBlocks: [
      BlogContentBlockModel(
        type: BlogContentBlockType.paragraph,
        text:
            'As winter approaches, solar homeowners face unique challenges. Cold temperatures affect battery chemistry, reducing capacity and efficiency. With the right strategies, you can protect your storage investment and maintain reliable backup power all season long.',
      ),
      BlogContentBlockModel(
        type: BlogContentBlockType.heading,
        text: 'Maintaining Optimal Temperatures',
      ),
      BlogContentBlockModel(
        type: BlogContentBlockType.paragraph,
        text:
            'Lithium batteries perform best between 15°C and 25°C (59°F–77°F). When temperatures drop below freezing, internal resistance increases and usable capacity can fall by 20% or more.',
      ),
      BlogContentBlockModel(
        type: BlogContentBlockType.proTip,
        proTipTitle: 'Insulation Matters',
        text:
            'Consider installing your battery in a garage or utility room rather than an unheated exterior wall. Thermal wrapping kits are available for outdoor installations and can extend usable capacity during cold snaps.',
      ),
      BlogContentBlockModel(
        type: BlogContentBlockType.heading,
        text: 'Adjusting Your Discharge Strategy',
      ),
      BlogContentBlockModel(
        type: BlogContentBlockType.paragraph,
        text:
            'During winter, avoid draining your battery below 30% State of Charge (SoC). Deep discharges in cold weather accelerate cell degradation and can trigger protective shutdowns.',
      ),
      BlogContentBlockModel(
        type: BlogContentBlockType.bulletList,
        items: [
          "Enable 'Winter Mode' in your SolarHub app settings.",
          'Monitor real-time voltage drops during morning startup.',
          'Schedule heavy appliance use during midday peak production.',
        ],
      ),
    ],
    relatedArticles: [
      BlogArticleModel(
        id: 'blog-related-1',
        title: '5 Tips for Post-Storm Solar Maintenance',
        excerpt:
            'Ensure your panels are clear of debris and inspect wiring after severe weather events to maintain peak output.',
        dateLabel: 'Oct 18, 2023',
        categoryKey: 'panels',
        categoryLabel: 'Panels',
        imagePlaceholderColorValue: 0xFF2A4A6C,
        iconType: 'document',
      ),
      BlogArticleModel(
        id: 'blog-related-2',
        title: 'Understanding Grid-Feed Tariffs in 2024',
        excerpt:
            'New policy changes are reshaping how excess solar energy is credited. Here is what homeowners need to know.',
        dateLabel: 'Oct 12, 2023',
        categoryKey: 'panels',
        categoryLabel: 'Panels',
        imagePlaceholderColorValue: 0xFF1E3348,
        iconType: 'inverter',
      ),
    ],
  );

  static final _fallbackArticles = <String, BlogArticleDetailModel>{
    'blog-2': _winterArticle,
    'blog-1': BlogArticleDetailModel(
      id: 'blog-1',
      title: 'How to Choose the Right Solar Panel',
      categoryBadge: 'PANELS',
      heroColorValue: 0xFFE8EDF2,
      author: const BlogAuthorModel(
        name: 'Michael Torres',
        role: 'Solar Product Specialist',
        dateLabel: 'October 24, 2023',
      ),
      contentBlocks: const [
        BlogContentBlockModel(
          type: BlogContentBlockType.paragraph,
          text:
              'Navigating the world of monocrystalline vs. polycrystalline panels can be tricky. This guide breaks down efficiency ratings, warranties, and cost-per-watt to help you make the best investment for your home.',
        ),
        BlogContentBlockModel(
          type: BlogContentBlockType.heading,
          text: 'Compare Efficiency Ratings',
        ),
        BlogContentBlockModel(
          type: BlogContentBlockType.paragraph,
          text:
              'Higher efficiency panels produce more power per square foot, which matters when roof space is limited. Look for ratings above 20% for premium residential installs.',
        ),
      ],
      relatedArticles: [
        _winterArticle.relatedArticles.first,
      ],
    ),
  };

  @override
  Future<BlogArticleDetailModel> getArticleDetail(String articleId) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _fallbackArticles[articleId] ?? _winterArticle;
  }
}
