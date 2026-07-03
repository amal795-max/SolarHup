import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/blog/data/data_source/blog_detail_remote_data_source.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';

abstract class BlogDetailRepository {
  Future<Either<Failure, BlogArticleDetailModel>> getArticleDetail(
    String articleId,
  );
}

class BlogDetailRepositoryImpl implements BlogDetailRepository {
  final BlogDetailRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const BlogDetailRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, BlogArticleDetailModel>> getArticleDetail(
    String articleId,
  ) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      final detail = await remote.getArticleDetail(articleId);
      return Right(detail);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
