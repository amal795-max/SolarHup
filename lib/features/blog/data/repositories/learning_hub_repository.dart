import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/blog/data/data_source/learning_hub_remote_data_source.dart';
import 'package:untitled1/features/blog/data/models/learning_hub_model.dart';

abstract class LearningHubRepository {
  Future<Either<Failure, LearningHubModel>> getLearningHub();
}

class LearningHubRepositoryImpl implements LearningHubRepository {
  final LearningHubRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const LearningHubRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, LearningHubModel>> getLearningHub() async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      final data = await remote.getLearningHub();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
