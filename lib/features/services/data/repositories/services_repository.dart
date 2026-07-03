import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/services_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/expert_service_model.dart';

abstract class ServicesRepository {
  Future<Either<Failure, ServicesFeedModel>> getServicesFeed();
}

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const ServicesRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, ServicesFeedModel>> getServicesFeed() async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      final data = await remote.getServicesFeed();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
