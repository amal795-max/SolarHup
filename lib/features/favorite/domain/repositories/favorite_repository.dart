import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/favorite/data/models/favorite_model.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<FavoriteModel>>> getFavorites(String itemType);
  Future<Either<Failure, Unit>> addFavorite(String itemType, int itemId);
  Future<Either<Failure, Unit>> deleteFavorite(String itemType, int itemId);
}
