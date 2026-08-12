import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final OrderModel cart;
  const CartSuccess(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartActionLoading extends CartState {}

class CartActionSuccess extends CartState {
  final String message;
  const CartActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CartActionError extends CartState {
  final String message;
  const CartActionError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrdersLoaded extends CartState {
  final List<OrderModel> orders;
  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

