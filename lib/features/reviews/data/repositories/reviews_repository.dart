import 'package:dartz/dartz.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failures.dart';
import '../../../../core/network/check_internet.dart';
import '../data_sources/reviews_remote_data_source.dart';
import '../models/review_model.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, List<ReviewModel>>> getReviews(String itemType, String itemId);
  Future<Either<Failure, Unit>> addReview(CreateReviewRequest request);
}

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource remote;
  final NetworkInfo networkInfo;

  ReviewsRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ReviewModel>>> getReviews(
      String itemType, String itemId) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.getReviews(itemType, itemId);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addReview(CreateReviewRequest request) async {
    if (await networkInfo.isConnected) {
      try {
        await remote.addReview(request);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
