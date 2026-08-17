import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository repository;
  List<OrderModel> cachedOrders = [];
  OrdersCubit(this.repository) : super(OrdersInitial());

  Future<void> getMyOrders({bool showLoading = false}) async {
    if (showLoading || cachedOrders.isEmpty) {
      emit(OrdersLoading());
    }
    final result = await repository.getMyOrders();
    result.fold((failure) => emit(OrdersError(failure.message)), (orders) {
      cachedOrders = orders;
      emit(OrdersLoaded(orders));
    });
  }

  Future<void> getOrderDetails(OrderModel order, {bool showLoading = false}) async {
    if (showLoading || state is! OrderDetailsLoaded) {
      emit(OrdersLoading());
    }
    final result = await repository.getOrderDetails(order.id);
    result.fold((failure) => emit(OrdersError(failure.message)), (
      orderResponse,
    ) {
      final index = cachedOrders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        cachedOrders[index] = orderResponse;
      }
      emit(OrderDetailsLoaded(orderResponse));
    });
  }
}
