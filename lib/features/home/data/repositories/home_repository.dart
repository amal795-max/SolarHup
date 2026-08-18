import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';
import 'package:untitled1/features/blog/data/repositories/blog_repository.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';
import 'package:untitled1/features/home/data/mappers/top_selling_product_mapper.dart';
import 'package:untitled1/features/stores/data/data_source/product_detail_remote_data_source.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import '../data_source/home_remote_data_source.dart';
import '../models/blog_model.dart';
import '../models/home_layout_model.dart';
import '../models/product_model.dart';
import '../models/tip_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<UsedProductModel>>> getUsedProducts();
  Future<Either<Failure, List<ProductModel>>> getTopSellingProducts({
    int limit = 10,
  });
  Future<Either<Failure, List<ProductModel>>> getTopSellingProductsForViewAll({
    int limit = 50,
  });
  Future<Either<Failure, List<ProductModel>>> getNewOffers();
  Future<Either<Failure, List<BlogModel>>> getBlogPosts();
  Future<Either<Failure, List<TipModel>>> getRandomTips();
  Future<Either<Failure, List<HomeLayoutModel>>> getHomeLayout();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;
  final CatalogRepository catalogRepository;
  final BlogRepository blogRepository;
  final ProductDetailRemoteDataSource productDetailRemote;
  final NetworkInfo networkInfo;
  final PromotionEligibilityService promotionEligibility;
  final bool useNetworkCheck;

  const HomeRepositoryImpl({
    required this.remote,
    required this.catalogRepository,
    required this.blogRepository,
    required this.productDetailRemote,
    required this.networkInfo,
    required this.promotionEligibility,
    this.useNetworkCheck = true,
  });

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() fn) async {
    if (!useNetworkCheck || await networkInfo.isConnected) {
      try {
        return Right(await fn());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (_) {
        return const Left(ServerFailure('Unexpected error'));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<HomeLayoutModel>>> getHomeLayout() async {
    final result = await _handle(() => remote.getHomeLayout());
    return result.map((list) {
      final sortedList = List<HomeLayoutModel>.from(list);
      sortedList.sort((a, b) => a.order.compareTo(b.order));
      return sortedList;
    });
  }

  @override
  Future<Either<Failure, List<UsedProductModel>>> getUsedProducts() =>
      _handle(() => remote.getUsedProducts());

  @override
  Future<Either<Failure, List<ProductModel>>> getTopSellingProducts({
    int limit = 10,
  }) async {
    final result = await _handle(
      () => remote.getTopSellingProducts(limit: limit),
    );
    return result.map(
      (products) => products
          .map((product) => product.toHomeProduct())
          .toList(growable: false),
    );
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getTopSellingProductsForViewAll({
    int limit = 50,
  }) async {
    if (!useNetworkCheck || await networkInfo.isConnected) {
      try {
        await promotionEligibility.ensureSynced();
        final usedPromotionIds = promotionEligibility.usedPromotionIds;
        final discounts = (await catalogRepository.getDiscounts(
          businessType: 'store',
        ))
            .getOrElse(() => const <DiscountModel>[]);
        final topSelling = await remote.getTopSellingProducts(limit: limit);
        final enriched = await Future.wait(
          topSelling.map((item) async {
            try {
              final detail = await productDetailRemote.getProductDetail(
                businessId: item.businessId,
                productId: item.id.toString(),
              );
              if (!detail.isAvailable) return null;

              final discount = findBestDiscountForProduct(
                discounts: discounts,
                businessId: item.businessId,
                productId: item.id.toString(),
                excludedPromotionIds: usedPromotionIds,
              );
              if (discount != null) {
                return discountedProductToHomeProduct(
                  mergeDiscountWithProductDetail(
                    candidate: discount,
                    detail: detail,
                  ),
                );
              }

              return productDetailToHomeProduct(
                detail: detail,
                businessId: item.businessId,
              );
            } on ServerException {
              return null;
            }
          }),
        );

        return Right(
          enriched.whereType<ProductModel>().toList(growable: false),
        );
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (_) {
        return const Left(ServerFailure('Unexpected error'));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getNewOffers() async {
    await promotionEligibility.ensureSynced();
    final usedPromotionIds = promotionEligibility.usedPromotionIds;
    final result = await catalogRepository.getDiscountedProducts(
      limit: 5,
      businessType: 'store',
    );
    return result.map(
      (products) => products
          .map(
            (product) => discountedProductToEligibleHomeProduct(
              product,
              usedPromotionIds: usedPromotionIds,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<Either<Failure, List<TipModel>>> getRandomTips() =>
      _handle(() => remote.getRandomTips());

  @override
  Future<Either<Failure, List<BlogModel>>> getBlogPosts() async {
    final result = await blogRepository.getBlogFeed();
    return result.map(_mapFeedToHomeBlogs);
  }

  List<BlogModel> _mapFeedToHomeBlogs(BlogFeedModel feed) {
    final articles = <BlogArticleModel>[];
    if (feed.featured.title.isNotEmpty) {
      articles.add(feed.featured);
    }
    articles.addAll(feed.articles);

    final seen = <String>{};
    final unique = <BlogArticleModel>[];
    for (final article in articles) {
      if (seen.add(article.id)) {
        unique.add(article);
      }
    }

    return unique.take(2).map(_toBlogModel).toList();
  }

  BlogModel _toBlogModel(BlogArticleModel article) {
    return BlogModel(
      id: article.id,
      title: article.title,
      meta: article.dateLabel,
      imagePlaceholderColorValue: article.imagePlaceholderColorValue,
      imageUrl: article.imageUrl,
    );
  }
}
