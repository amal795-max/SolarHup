import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';

abstract class BlogRepository {
  Future<Either<Failure, BlogFeedModel>> getBlogFeed();
}

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const BlogRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, BlogFeedModel>> getBlogFeed() async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return const Left(OfflineFailure());
    }
    try {
      final data = await remote.getBlogFeed();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
