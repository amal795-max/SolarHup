import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';
import 'package:untitled1/features/blog/data/models/faq_model.dart';

abstract class BlogRepository {
  Future<Either<Failure, BlogFeedModel>> getBlogFeed();
  Future<Either<Failure, List<FaqModel>>> getFaqs();
}

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remote;
  final NetworkInfo networkInfo;

  BlogRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, BlogFeedModel>> getBlogFeed() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.getBlogFeed();
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<FaqModel>>> getFaqs() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.getFaqs();
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
