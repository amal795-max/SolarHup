import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/features/orders/data/datasources/cart_remote_data_source.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';

import '../../../../core/constants/user-parameters.dart';
import '../../../../core/network/check_internet.dart';

abstract class CartRepository {
  Future<Either<Failure, OrderModel>> getCart();

  Future<Either<Failure, Unit>> addToCart(AddProductToCartParams params);

  Future<Either<Failure, Unit>> clearCart();

  Future<Either<Failure, Unit>> updateCartItem(AddProductToCartParams params);

  Future<Either<Failure, Unit>> deleteCartItem(int productId);
  Future<Either<Failure, Unit>> submitCart(ShippingInformationParams params);
}

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderModel>> getCart() async {
    if (await networkInfo.isConnected) {
      try {
        final cart = await remoteDataSource.getCart();
        LocalStorage().saveData(key: ApiKeys.orderId, value: cart.id);
        return Right(cart);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addToCart(AddProductToCartParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addToCart(params);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.clearCart();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCartItem(AddProductToCartParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateCartItem(params);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCartItem(int productId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteCartItem(productId);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }


  @override
  Future<Either<Failure, Unit>> submitCart(ShippingInformationParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.submitCart(params);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
