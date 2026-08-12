import 'package:dartz/dartz.dart';
import '../../../../core/api/errors/failures.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/network/check_internet.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/order_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderModel>>> getMyOrders();
  Future<Either<Failure, OrderModel>> getOrderDetails(int orderId);
}

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<OrderModel>>> getMyOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final orders = await remoteDataSource.getMyOrders();
        return Right(orders);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderDetails(int orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.getOrderDetails(orderId);
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
