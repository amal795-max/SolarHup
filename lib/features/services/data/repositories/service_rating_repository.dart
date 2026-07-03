import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/service_rating_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/service_rating_model.dart';

abstract class ServiceRatingRepository {
  Future<Either<Failure, ServiceRatingModel>> getServiceRating(
    String serviceId,
  );
  Future<Either<Failure, void>> submitServiceRating(
    ServiceRatingSubmissionModel submission,
  );
}

class ServiceRatingRepositoryImpl implements ServiceRatingRepository {
  final ServiceRatingRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const ServiceRatingRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, ServiceRatingModel>> getServiceRating(
    String serviceId,
  ) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      final data = await remote.getServiceRating(serviceId);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitServiceRating(
    ServiceRatingSubmissionModel submission,
  ) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      await remote.submitServiceRating(submission);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
