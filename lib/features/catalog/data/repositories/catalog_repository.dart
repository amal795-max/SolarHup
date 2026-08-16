import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/catalog/data/data_source/catalog_remote_data_source.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/catalog/data/models/discounted_product_model.dart';
import 'package:untitled1/features/stores/data/data_source/product_detail_remote_data_source.dart';

abstract class CatalogRepository {
  Future<Either<Failure, List<DiscountModel>>> getDiscounts({
    String? businessType,
  });
  Future<Either<Failure, List<DiscountedProductModel>>> getDiscountedProducts({
    int? limit,
    String? businessType,
  });
  Future<Either<Failure, List<DiscountedProductModel>>>
      getDiscountedProductPreviews({
    int? limit,
    String? businessType,
  });
  Future<Either<Failure, List<DiscountedProductModel>>> getStoreDiscountedProducts(
    int businessId, {
    int? limit,
  });
  Future<Either<Failure, List<DiscountModel>>> getStoreDiscounts(int businessId);
  Future<Either<Failure, List<DiscountModel>>> getWorkshopDiscounts(int businessId);
}

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remote;
  final ProductDetailRemoteDataSource productDetailRemote;
  final NetworkInfo networkInfo;

  CatalogRepositoryImpl({
    required this.remote,
    required this.productDetailRemote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DiscountModel>>> getDiscounts({
    String? businessType,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }
    try {
      final discounts = await remote.getDiscounts(businessType: businessType);
      return Right(discounts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DiscountedProductModel>>> getDiscountedProducts({
    int? limit,
    String? businessType,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }
    try {
      final discounts = await remote.getDiscounts(businessType: businessType);
      final products = await _enrichDiscountProducts(discounts, limit: limit);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DiscountedProductModel>>>
      getDiscountedProductPreviews({
    int? limit,
    String? businessType,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }
    try {
      final discounts = await remote.getDiscounts(businessType: businessType);
      final candidates = topDiscountCandidates(discounts, limit: limit);
      return Right(
        candidates.map(candidateToDiscountedProductPreview).toList(),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DiscountedProductModel>>>
      getStoreDiscountedProducts(
    int businessId, {
    int? limit,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }
    try {
      final discounts = await remote.getStoreDiscounts(businessId);
      final products = await _enrichDiscountProducts(discounts, limit: limit);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DiscountModel>>> getStoreDiscounts(
    int businessId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }
    try {
      final discounts = await remote.getStoreDiscounts(businessId);
      return Right(discounts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DiscountModel>>> getWorkshopDiscounts(
    int businessId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }
    try {
      final discounts = await remote.getWorkshopDiscounts(businessId);
      return Right(discounts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<List<DiscountedProductModel>> _enrichDiscountProducts(
    List<DiscountModel> discounts, {
    int? limit,
  }) async {
    final candidates = flattenDiscountProducts(discounts);
    final items = limit == null ? candidates : candidates.take(limit).toList();
    final enriched = <DiscountedProductModel>[];

    await Future.wait(
      items.map((candidate) async {
        try {
          final detail = await productDetailRemote.getProductDetail(
            businessId: candidate.businessId,
            productId: candidate.productId,
          );
          if (!detail.isAvailable) return;
          enriched.add(
            mergeDiscountWithProductDetail(
              candidate: candidate,
              detail: detail,
            ),
          );
        } on ServerException {
          // Skip products that fail to load individually.
        }
      }),
    );

    enriched.sort(
      (a, b) => (b.discountPercent ?? 0).compareTo(a.discountPercent ?? 0),
    );
    return enriched;
  }
}
