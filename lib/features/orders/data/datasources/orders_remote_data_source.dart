import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/constants/app_url.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getMyOrders();
  Future<OrderModel> getOrderDetails(int orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiRequest apiRequest;

  OrdersRemoteDataSourceImpl({required this.apiRequest});

  @override
  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await apiRequest.get(EndPoints.myOrders);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return (response.data['orders'] as List)
            .map((e) => OrderModel.fromJson(e))
            .toList();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<OrderModel> getOrderDetails(int orderId) async {
    try {
      final response = await apiRequest.get(EndPoints.orderDetails(orderId));
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return OrderModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
