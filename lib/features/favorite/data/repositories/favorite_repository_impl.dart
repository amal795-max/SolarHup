import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/favorite/data/data_sources/favorite_remote_data_source.dart';
import 'package:untitled1/features/favorite/data/models/favorite_model.dart';
import 'package:untitled1/features/favorite/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FavoriteRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FavoriteModel>>> getFavorites(String itemType) async {
    if (await networkInfo.isConnected) {
      try {
        final favorites = await remoteDataSource.getFavorites(itemType);
        return Right(favorites);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addFavorite(String itemType, int itemId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addFavorite(itemType, itemId);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFavorite(String itemType, int itemId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteFavorite(itemType, itemId);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
