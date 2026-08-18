import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';
import '../../services/promotion_eligibility_service.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository repository;
  final PromotionEligibilityService promotionEligibility;
  List<OrderModel> cachedOrders = [];
  OrdersCubit(this.repository, this.promotionEligibility)
      : super(OrdersInitial());

  Future<void> getMyOrders({bool showLoading = false}) async {
    if (showLoading || cachedOrders.isEmpty) {
      emit(OrdersLoading());
    }
    final result = await repository.getMyOrders();
    result.fold((failure) => emit(OrdersError(failure.message)), (orders) {
      cachedOrders = orders;
      promotionEligibility.syncFromOrderList(orders);
      emit(OrdersLoaded(orders));
    });
  }

  Future<void> getOrderDetails(OrderModel order) async {
    await getOrderDetailsById(order.id);
  }

  Future<void> getOrderDetailsById(int orderId) async {
    if (orderId <= 0) {
      emit(const OrdersError('Invalid order'));
      return;
    }

    emit(OrdersLoading());

    final result = await repository.getOrderDetails(orderId);
    result.fold((failure) => emit(OrdersError(failure.message)), (
      orderResponse,
    ) {
      final index = cachedOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        cachedOrders[index] = orderResponse;
      }
      emit(OrderDetailsLoaded(orderResponse));
    });
  }
}
