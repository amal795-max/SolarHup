import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/service_requests_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';

abstract class ServiceRequestsRepository {
  Future<Either<Failure, ServiceRequestModel>> createServiceRequest(
    int serviceId,
  );
  Future<Either<Failure, List<ServiceRequestModel>>> getMyServiceRequests();
}

class ServiceRequestsRepositoryImpl implements ServiceRequestsRepository {
  final ServiceRequestsRemoteDataSource remote;
  final NetworkInfo networkInfo;

  ServiceRequestsRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ServiceRequestModel>> createServiceRequest(
    int serviceId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final request = await remote.createServiceRequest(serviceId);
        return Right(request);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(OfflineFailure());
  }

  @override
  Future<Either<Failure, List<ServiceRequestModel>>>
      getMyServiceRequests() async {
    if (await networkInfo.isConnected) {
      try {
        final requests = await remote.getMyServiceRequests();
        return Right(requests);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(OfflineFailure());
  }
}
