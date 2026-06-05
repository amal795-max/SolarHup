import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
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
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const HomeRepositoryImpl({
    required this.remote,
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
        return Left(ServerFailure('Unexpected error'));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getUsedProducts() =>
      _handle(() => remote.getUsedProducts());

  @override
  Future<Either<Failure, List<ProductModel>>> getNewOffers() =>
      _handle(() => remote.getNewOffers());

  @override
  Future<Either<Failure, List<BlogModel>>> getBlogPosts() =>
      _handle(() => remote.getBlogPosts());
}
