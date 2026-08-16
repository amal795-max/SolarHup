import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/workshops_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/workshop_availability_model.dart';
import 'package:untitled1/features/services/data/models/workshop_detail_model.dart';
import 'package:untitled1/features/services/data/models/workshop_offering_model.dart';
import 'package:untitled1/features/services/data/models/workshop_service_model.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';

abstract class WorkshopsRepository {
  Future<Either<Failure, List<StoreCategoryModel>>> getWorkshopCategories();
  Future<Either<Failure, WorkshopDetailModel>> getWorkshop(String businessId);
  Future<Either<Failure, List<WorkshopServiceModel>>> getWorkshopServices(
    String businessId, {
    int? categoryId,
  });
  Future<Either<Failure, List<WorkshopOfferingModel>>> getOfferingsForCategory(
    int categoryId,
  );
  Future<Either<Failure, WorkshopAvailabilityModel>> getWorkshopAvailability(
    int businessId,
  );
}

class WorkshopsRepositoryImpl implements WorkshopsRepository {
  final WorkshopsRemoteDataSource remote;
  final NetworkInfo networkInfo;

  WorkshopsRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<StoreCategoryModel>>>
      getWorkshopCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remote.getWorkshopCategories();
        return Right(categories);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(OfflineFailure());
  }

  @override
  Future<Either<Failure, WorkshopDetailModel>> getWorkshop(
    String businessId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final workshop = await remote.getWorkshop(businessId);
        return Right(workshop);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(OfflineFailure());
  }

  @override
  Future<Either<Failure, List<WorkshopServiceModel>>> getWorkshopServices(
    String businessId, {
    int? categoryId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final services =
            await remote.getWorkshopServices(businessId, categoryId: categoryId);
        return Right(services);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(OfflineFailure());
  }

  @override
  Future<Either<Failure, List<WorkshopOfferingModel>>> getOfferingsForCategory(
    int categoryId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final offerings = await remote.getOfferingsForCategory(categoryId);
        return Right(offerings);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(OfflineFailure());
  }

  @override
  Future<Either<Failure, WorkshopAvailabilityModel>> getWorkshopAvailability(
    int businessId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final availability = await remote.getWorkshopAvailability(businessId);
        return Right(availability);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(OfflineFailure());
  }
}
