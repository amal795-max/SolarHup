import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/stores/data/data_source/product_detail_remote_data_source.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

abstract class ProductDetailRepository {
  Future<Either<Failure, ProductDetailModel>> getProductDetail({
    required String businessId,
    required String productId,
  });
}

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailRemoteDataSource remote;
  final NetworkInfo networkInfo;

  ProductDetailRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductDetailModel>> getProductDetail({
    required String businessId,
    required String productId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remote.getProductDetail(
          businessId: businessId,
          productId: productId,
        );
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
