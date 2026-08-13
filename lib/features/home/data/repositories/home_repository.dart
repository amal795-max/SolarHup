import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';
import 'package:untitled1/features/blog/data/repositories/blog_repository.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import '../data_source/home_remote_data_source.dart';
import '../models/blog_model.dart';
import '../models/product_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ProductModel>>> getUsedProducts();
  Future<Either<Failure, List<ProductModel>>> getNewOffers();
  Future<Either<Failure, List<BlogModel>>> getBlogPosts();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;
  final CatalogRepository catalogRepository;
  final BlogRepository blogRepository;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const HomeRepositoryImpl({
    required this.remote,
    required this.catalogRepository,
    required this.blogRepository,
    required this.networkInfo,
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
  Future<Either<Failure, List<ProductModel>>> getUsedProducts() =>
      _handle(() => remote.getUsedProducts());

  @override
  Future<Either<Failure, List<ProductModel>>> getNewOffers() async {
    final result = await catalogRepository.getDiscountedProducts(
      limit: 6,
      businessType: 'store',
    );
    return result.map(
      (products) =>
          products.map(discountedProductToHomeProduct).toList(growable: false),
    );
  }

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
      iconType: article.iconType == 'finance' ? 'finance' : 'sun',
    );
  }
}
