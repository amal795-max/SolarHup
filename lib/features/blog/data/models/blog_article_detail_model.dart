import 'blog_article_model.dart';

enum BlogContentBlockType { paragraph, heading, proTip, bulletList }

class BlogContentBlockModel {
  final BlogContentBlockType type;
  final String? text;
  final String? proTipTitle;
  final List<String>? items;

  const BlogContentBlockModel({
    required this.type,
    this.text,
    this.proTipTitle,
    this.items,
  });
}

class BlogSponsoredProductModel {
  final String storeName;
  final String title;
  final String subtitle;
  final double price;

  const BlogSponsoredProductModel({
    required this.storeName,
    required this.title,
    required this.subtitle,
    required this.price,
  });
}

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
  final BlogAuthorModel author;
  final BlogSponsoredProductModel? sponsoredProduct;
  final List<BlogContentBlockModel> contentBlocks;
  final List<BlogArticleModel> relatedArticles;

  const BlogArticleDetailModel({
    required this.id,
    required this.title,
    required this.categoryBadge,
    required this.heroColorValue,
    required this.author,
    required this.contentBlocks,
    required this.relatedArticles,
    this.sponsoredProduct,
  });
}
