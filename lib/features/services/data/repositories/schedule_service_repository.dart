import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/schedule_service_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/schedule_service_model.dart';

abstract class ScheduleServiceRepository {
  Future<Either<Failure, ScheduleServiceModel>> getScheduleService(
    String serviceId,
  );
}

class ScheduleServiceRepositoryImpl implements ScheduleServiceRepository {
  final ScheduleServiceRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const ScheduleServiceRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, ScheduleServiceModel>> getScheduleService(
    String serviceId,
  ) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return const Left(OfflineFailure());
    }
    try {
      final data = await remote.getScheduleService(serviceId);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
