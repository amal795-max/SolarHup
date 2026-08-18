import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/catalog/data/data_source/catalog_remote_data_source.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';
import 'package:untitled1/features/stores/data/data_source/product_detail_remote_data_source.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

abstract class ProductDetailRepository {
  Future<Either<Failure, ProductDetailModel>> getProductDetail({
    required int businessId,
    required String productId,
  });
}

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailRemoteDataSource remote;
  final CatalogRemoteDataSource catalogRemote;
  final NetworkInfo networkInfo;
  final PromotionEligibilityService promotionEligibility;

  ProductDetailRepositoryImpl({
    required this.remote,
    required this.catalogRemote,
    required this.networkInfo,
    required this.promotionEligibility,
  });

  @override
  Future<Either<Failure, ProductDetailModel>> getProductDetail({
    required int businessId,
    required String productId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }
    try {
      final product = await remote.getProductDetail(
        businessId: businessId,
        productId: productId,
      );

      try {
        await promotionEligibility.ensureSynced();
        final discounts = await catalogRemote.getStoreDiscounts(businessId);
        final candidate = findBestDiscountForProduct(
          discounts: discounts,
          businessId: businessId,
          productId: productId,
          excludedPromotionIds: promotionEligibility.usedPromotionIds,
        );
        if (candidate != null) {
          return Right(
            applyDiscountToProductDetail(
              product: product,
              candidate: candidate,
            ),
          );
        }
      } on ServerException {
        // Fall back to retail pricing if discount lookup fails.
      }

      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
