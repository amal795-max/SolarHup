import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/data/repositories/orders_repository.dart';

/// Tracks store promotions the current user has already redeemed.
///
/// Used to show full retail pricing in catalog UI and to avoid sending
/// ineligible [promotion_id] values during cart submit.
class PromotionEligibilityService {
  final OrdersRepository _ordersRepository;
  final Set<int> _usedPromotionIds = {};
  bool _syncedWithOrders = false;
  bool _hydratedFromStorage = false;

  PromotionEligibilityService(this._ordersRepository);

  Set<int> get usedPromotionIds {
    _ensureHydratedFromStorage();
    return Set.unmodifiable(_usedPromotionIds);
  }

  bool isEligible(int? promotionId) {
    if (promotionId == null || promotionId <= 0) return true;
    _ensureHydratedFromStorage();
    return !_usedPromotionIds.contains(promotionId);
  }

  Future<void> ensureSynced() async {
    if (_syncedWithOrders) return;

    final result = await _ordersRepository.getMyOrders();
    result.fold((_) {}, syncFromOrderList);
    _syncedWithOrders = true;
  }

  void syncFromOrderList(List<OrderModel> orders) {
    var changed = false;
    for (final order in orders) {
      final promotionId = order.appliedPromotionId;
      if (promotionId != null &&
          promotionId > 0 &&
          _usedPromotionIds.add(promotionId)) {
        changed = true;
      }
    }
    if (changed) {
      _persist();
    }
  }

  void markUsed(int promotionId) {
    if (promotionId <= 0) return;
    if (_usedPromotionIds.add(promotionId)) {
      _persist();
    }
  }

  void clear() {
    _usedPromotionIds.clear();
    _syncedWithOrders = false;
    LocalStorage().removeData(key: ApiKeys.usedPromotionIds);
  }

  void _ensureHydratedFromStorage() {
    if (_hydratedFromStorage) return;
    _hydratedFromStorage = true;

    try {
      final raw = LocalStorage().getDataString(key: ApiKeys.usedPromotionIds);
      if (raw == null || raw.trim().isEmpty) return;

      for (final part in raw.split(',')) {
        final id = int.tryParse(part.trim());
        if (id != null && id > 0) {
          _usedPromotionIds.add(id);
        }
      }
    } catch (_) {
      // Local storage may not be initialized yet (e.g. unit tests).
    }
  }

  Future<void> _persist() async {
    try {
      final value = _usedPromotionIds.join(',');
      if (value.isEmpty) {
        await LocalStorage().removeData(key: ApiKeys.usedPromotionIds);
        return;
      }
      await LocalStorage().saveData(key: ApiKeys.usedPromotionIds, value: value);
    } catch (_) {
      // Local storage may not be initialized yet (e.g. unit tests).
    }
  }
}
