import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../core/constants/user-parameters.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<OrderModel> getCart();

  Future<void> addToCart(AddProductToCartParams params);

  Future<void> clearCart();

  Future<void> updateCartItem(AddProductToCartParams params);

  Future<void> deleteCartItem(int productId);
  Future<void> submitCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiRequest apiRequest;

  CartRemoteDataSourceImpl({required this.apiRequest});

  @override
  Future<OrderModel> getCart() async {
    try {
      final response = await apiRequest.get(EndPoints.cart);

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

  @override
  Future<void> addToCart(AddProductToCartParams params) async {
    try {
      final response = await apiRequest.post(EndPoints.cartItems,
        body: params.toJson(),
      );
      if (response.statusCode != 201) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return response.data['exists'];
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final response = await apiRequest.delete(EndPoints.cart);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return response.data['exists'];
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> deleteCartItem(int productId) async {
    try {
      final response = await apiRequest.delete(
          '${EndPoints.cartItems}/$productId');
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return;
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> updateCartItem(AddProductToCartParams params) async {
    try {
      final response = await apiRequest.post(
        EndPoints.cartItems, body:
      params.toJson());
      if (response.statusCode != 201) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return;
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> submitCart() async{
    try {
      final response = await apiRequest.post(EndPoints.submitCart);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return;
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}