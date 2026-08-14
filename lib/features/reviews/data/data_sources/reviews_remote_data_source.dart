import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/constants/app_url.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../models/review_model.dart';

abstract class ReviewsRemoteDataSource {
  Future<List<ReviewModel>> getReviews(String itemType, String itemId);
  Future<void> addReview(CreateReviewRequest request);
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final ApiRequest apiRequest;

  ReviewsRemoteDataSourceImpl({required this.apiRequest});

  @override
  Future<List<ReviewModel>> getReviews(String itemType, String itemId) async {
    try {
      final response = await apiRequest.get(
        EndPoints.reviews,
        query: {
          'item_type': itemType,
          'item_id': itemId,
        },
      );

      final status = response.statusCode ?? 0;
      if (status != 200) {
        throw ServerException(message: getErrorMessage(status));
      }

      final List data = response.data['reviews'] ?? [];
      return data.map((e) => ReviewModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> addReview(CreateReviewRequest request) async {
    try {
      final response = await apiRequest.post(
        EndPoints.reviews,
        body: request.toJson(),
      );

      final status = response.statusCode ?? 0;
      if (status ==409) {
        throw ServerException(message: response.data['detail']);
      }   if (status != 200 && status != 201) {
        throw ServerException(message: getErrorMessage(status));
      }

    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
