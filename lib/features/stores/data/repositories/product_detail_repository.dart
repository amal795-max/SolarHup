import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/stores/data/data_source/product_detail_remote_data_source.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

abstract class ProductDetailRepository {
  Future<Either<Failure, ProductDetailModel>> getProductDetail(String productId);
}

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const ProductDetailRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, ProductDetailModel>> getProductDetail(
    String productId,
  ) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return const Left(OfflineFailure());
    }
    try {
      final product = await remote.getProductDetail(productId);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
