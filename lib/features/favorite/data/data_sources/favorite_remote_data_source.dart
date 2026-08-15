import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/favorite/data/models/favorite_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<List<FavoriteModel>> getFavorites(String itemType);
  Future<void> addFavorite(
    String itemType,
    int itemId, {
    int? workshopId,
  });
  Future<void> deleteFavorite(String itemType, int itemId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final ApiRequest apiRequest;

  FavoriteRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<List<FavoriteModel>> getFavorites(String itemType) async {
    try {
      final response = await apiRequest.get(
        EndPoints.favorites,
        query: {'item_type': itemType},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        final favorites = response.data['favorites'];
        final items = favorites is List ? favorites : const [];
        return items
            .whereType<Map<String, dynamic>>()
            .map(FavoriteModel.fromJson)
            .toList();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> addFavorite(
    String itemType,
    int itemId, {
    int? workshopId,
  }) async {
    try {
      final body = <String, dynamic>{
        'item_type': itemType,
        'item_id': itemId,
      };
      if (workshopId != null) {
        body['workshop_id'] = workshopId;
      }

      final response = await apiRequest.post(
        EndPoints.favorites,
        body: body,
      );
      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          response.statusCode == 409) {
        return;
      }
      throw ServerException(
        message: getErrorMessage(response.statusCode ?? 0),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) return;
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> deleteFavorite(String itemType, int itemId) async {
    try {
      final response = await apiRequest.delete(
        EndPoints.favoriteItem(itemType, itemId),
      );
      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 404) {
        return;
      }
      throw ServerException(
        message: getErrorMessage(response.statusCode ?? 0),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      throw ServerException(message: mapDioError(e));
    }
  }
}
