import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
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

  BlogDetailRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, BlogArticleDetailModel>> getArticleDetail(
    String articleId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final detail = await remote.getArticleDetail(articleId);
        return Right(detail);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
