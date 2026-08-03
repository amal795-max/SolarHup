import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/used_system/data/data-source/used_system_remote_data_source.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';

abstract class UsedSystemRepository {
  Future<Either<Failure, UsedProductModel>> addUsedProduct(AddUsedProductParams params);
  Future<Either<Failure, List<UsedProductModel>>> getUsedProducts(Map<String,dynamic> query);
  Future<Either<Failure, List<UsedProductModel>>> getMyUsedProducts();
}

class UsedSystemRepositoryImpl implements UsedSystemRepository {
  final UsedSystemRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UsedSystemRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UsedProductModel>> addUsedProduct(AddUsedProductParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addUsedProduct(params);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<UsedProductModel>>> getUsedProducts(Map<String,dynamic> query) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUsedProducts(query);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<UsedProductModel>>> getMyUsedProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyUsedProducts();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
