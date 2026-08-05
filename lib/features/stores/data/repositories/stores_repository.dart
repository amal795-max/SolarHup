import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/stores/data/data_source/stores_remote_data_source.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';
import 'package:untitled1/features/stores/data/models/store_detail_model.dart';
import 'package:untitled1/features/stores/data/models/store_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';

abstract class StoresRepository {
  Future<Either<Failure, List<StoreModel>>> getStores({String? region});
  Future<Either<Failure, StoreDetailModel>> getStore(String businessId);
  Future<Either<Failure, List<StoreCategoryModel>>> getStoreCategories();
  Future<Either<Failure, List<StoreProductModel>>> getStoreProducts(
    String businessId, {
    int? categoryId,
  });
}

class StoresRepositoryImpl implements StoresRepository {
  final StoresRemoteDataSource remote;
  final NetworkInfo networkInfo;

  StoresRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<StoreModel>>> getStores({String? region}) async {
    if (await networkInfo.isConnected) {
      try {
        final stores = await remote.getStores(region: region);
        return Right(stores);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, StoreDetailModel>> getStore(String businessId) async {
    if (await networkInfo.isConnected) {
      try {
        final store = await remote.getStore(businessId);
        return Right(store);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<StoreCategoryModel>>> getStoreCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remote.getStoreCategories();
        return Right(categories);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<StoreProductModel>>> getStoreProducts(
    String businessId, {
    int? categoryId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products =
            await remote.getStoreProducts(businessId, categoryId: categoryId);
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
