import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/service_address_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/service_address_model.dart';

abstract class ServiceAddressRepository {
  Future<Either<Failure, ServiceAddressModel>> getServiceAddress(
    String serviceId,
  );
}

class ServiceAddressRepositoryImpl implements ServiceAddressRepository {
  final ServiceAddressRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const ServiceAddressRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, ServiceAddressModel>> getServiceAddress(
    String serviceId,
  ) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      final data = await remote.getServiceAddress(serviceId);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
