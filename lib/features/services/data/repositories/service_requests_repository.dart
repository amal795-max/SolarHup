import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/service_requests_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/service_coupon_validation_model.dart';
import 'package:untitled1/features/services/data/models/service_request_create_payload.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';

abstract class ServiceRequestsRepository {
  Future<Either<Failure, ServiceRequestModel>> createServiceRequest(
    ServiceRequestCreatePayload payload,
  );
  Future<Either<Failure, ServiceCouponValidationModel>> validateCoupon({
    required int serviceId,
    required String couponCode,
  });
  Future<Either<Failure, List<ServiceRequestModel>>> getMyServiceRequests();
  Future<Either<Failure, ServiceRequestModel>> getServiceRequest(int requestId);
  Future<Either<Failure, ServiceRequestModel>> cancelServiceRequest(
    int requestId,
  );
}

class ServiceRequestsRepositoryImpl implements ServiceRequestsRepository {
  final ServiceRequestsRemoteDataSource remote;
  final NetworkInfo networkInfo;

  ServiceRequestsRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ServiceRequestModel>> createServiceRequest(
    ServiceRequestCreatePayload payload,
  ) {
    return _guard(() => remote.createServiceRequest(payload));
  }

  @override
  Future<Either<Failure, ServiceCouponValidationModel>> validateCoupon({
    required int serviceId,
    required String couponCode,
  }) {
    return _guard(
      () => remote.validateCoupon(
        serviceId: serviceId,
        couponCode: couponCode,
      ),
    );
  }

  @override
  Future<Either<Failure, List<ServiceRequestModel>>>
      getMyServiceRequests() {
    return _guard(remote.getMyServiceRequests);
  }

  @override
  Future<Either<Failure, ServiceRequestModel>> getServiceRequest(
    int requestId,
  ) {
    return _guard(() => remote.getServiceRequest(requestId));
  }

  @override
  Future<Either<Failure, ServiceRequestModel>> cancelServiceRequest(
    int requestId,
  ) {
    return _guard(() => remote.cancelServiceRequest(requestId));
  }
}
