import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/constants/failure_success_message.dart';
import 'package:untitled1/core/enums/favorite_category_enum.dart';
import 'package:untitled1/features/favorite/data/models/favorite_model.dart';
import 'package:untitled1/features/favorite/domain/repositories/favorite_repository.dart';
import '../../../../core/api/errors/exceptions.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteRepository repository;
  List<FavoriteModel> _cachedFavorites = [];
  String _currentCategory = FavoriteCategoryEnum.product.name;
  final Map<String, Set<int>> _favoriteIdsByType = {};
  final Set<String> _prefetchInFlight = {};
  final Set<String> _pendingToggles = {};
  int _cacheRevision = 0;

  FavoritesCubit(this.repository) : super(FavoritesInitial()) {
    unawaited(_prefetchInitialFavorites());
  }

  Future<void> _prefetchInitialFavorites() async {
    await Future.wait([
      prefetchFavorites(FavoriteCategoryEnum.product.name),
      prefetchFavorites(FavoriteCategoryEnum.service.name),
      prefetchFavorites(FavoriteCategoryEnum.store.name),
    ]);
    emit(FavoritesCacheReady(_cacheRevision));
  }

  void _emitFavoriteCacheChanged() {
    _cacheRevision++;
    emit(FavoritesCacheReady(_cacheRevision));
  }

  Future<void> prefetchFavorites(String itemType) async {
    if (_favoriteIdsByType.containsKey(itemType) ||
        _prefetchInFlight.contains(itemType)) {
      return;
    }

    _prefetchInFlight.add(itemType);
    try {
      final result = await repository.getFavorites(itemType);
      result.fold((_) => _favoriteIdsByType[itemType] = {}, (items) {
        _favoriteIdsByType[itemType] = items.map((item) => item.itemId).toSet();
        _cacheFavoriteMetadata(items);
        if (itemType == _currentCategory) {
          _cachedFavorites = items;
        }
      });
    } finally {
      _prefetchInFlight.remove(itemType);
    }
  }

  Future<void> loadFavorites(String category, {bool showLoading = false}) async {
    _currentCategory = category;
    final hasCategoryCache = state is FavoritesSuccess &&
        (state as FavoritesSuccess).category == category &&
        (state as FavoritesSuccess).items.isNotEmpty;
    if (showLoading || !hasCategoryCache) {
      emit(FavoritesLoading(category));
    }
    final result = await repository.getFavorites(category);

    result.fold((failure) => emit(FavoritesError(failure.message, category)), (
      items,
    ) {
      _cachedFavorites = items;
      _favoriteIdsByType[category] = items.map((item) => item.itemId).toSet();
      _cacheFavoriteMetadata(items);
      emit(FavoritesSuccess(items: items, category: category));
    });
  }

  Future<void> toggleFavorite(
    String itemType,
    int itemId, {
    int? workshopId,
    String? workshopName,
  }) async {
    if (itemType == FavoriteCategoryEnum.service.name &&
        workshopId == null &&
        !isFavorite(itemType, itemId)) {
      return;
    }

    final actionKey = '$itemType:$itemId';
    if (_pendingToggles.contains(actionKey)) return;
    _pendingToggles.add(actionKey);

    final removing = isFavorite(itemType, itemId);

    try {
      if (removing) {
        _removeFromCache(itemType, itemId);
        _emitListUpdate();

        final result = await repository.deleteFavorite(itemType, itemId);
        await result.fold(
          (failure) async {
            _favoriteIdsByType.putIfAbsent(itemType, () => {}).add(itemId);
            if (itemType == _currentCategory) {
              await _refreshCurrentCategorySilently();
            } else {
              _emitListUpdate();
            }
            _emitActionFeedback(mapFailureToMessage(failure), isError: true);
          },
          (_) async {
            if (itemType == FavoriteCategoryEnum.service.name) {
              _serviceWorkshopIds.remove(itemId);
              _serviceWorkshopNames.remove(itemId);
            }
            _emitActionFeedback(deleteFavoriteSuccessfully, isError: false);
          },
        );
      } else {
        if (itemType == FavoriteCategoryEnum.service.name &&
            workshopId != null) {
          rememberServiceWorkshop(
            serviceId: itemId,
            workshopId: workshopId,
            workshopName: workshopName,
          );
        }

        _favoriteIdsByType.putIfAbsent(itemType, () => {}).add(itemId);
        _emitFavoriteCacheChanged();

        final result = await repository.addFavorite(
          itemType,
          itemId,
          workshopId: workshopId,
        );
        await result.fold(
          (failure) async {
            _favoriteIdsByType[itemType]?.remove(itemId);
            if (itemType == FavoriteCategoryEnum.service.name) {
              _serviceWorkshopIds.remove(itemId);
              _serviceWorkshopNames.remove(itemId);
            }
            _emitFavoriteCacheChanged();
            _emitActionFeedback(mapFailureToMessage(failure), isError: true);
          },
          (_) async {
            if (itemType == _currentCategory) {
              await _refreshCurrentCategorySilently();
            }
            _emitActionFeedback(addedToFavoriteSuccessfully, isError: false);
          },
        );
      }
    } finally {
      _pendingToggles.remove(actionKey);
    }
  }

  bool isFavorite(String itemType, int itemId) {
    return _favoriteIdsByType[itemType]?.contains(itemId) ?? false;
  }

  List<FavoriteModel> get cachedFavorites =>
      List.unmodifiable(_cachedFavorites);

  final Map<int, int> _productBusinessIds = {};
  final Map<int, int> _serviceWorkshopIds = {};
  final Map<int, String> _serviceWorkshopNames = {};

  void rememberProductBusiness(int productId, int businessId) {
    if (businessId > 0) {
      _productBusinessIds[productId] = businessId;
    }
  }

  int? businessIdForProduct(int productId) => _productBusinessIds[productId];

  void rememberServiceWorkshop({
    required int serviceId,
    required int workshopId,
    String? workshopName,
  }) {
    if (workshopId <= 0) return;
    _serviceWorkshopIds[serviceId] = workshopId;
    if (workshopName != null && workshopName.trim().isNotEmpty) {
      _serviceWorkshopNames[serviceId] = workshopName.trim();
    }
  }

  int? workshopIdForService(int serviceId) => _serviceWorkshopIds[serviceId];

  String? workshopNameForService(int serviceId) =>
      _serviceWorkshopNames[serviceId];

  void _cacheFavoriteMetadata(List<FavoriteModel> items) {
    for (final item in items) {
      if (item.itemType == FavoriteCategoryEnum.product.name &&
          item.businessId != null) {
        rememberProductBusiness(item.itemId, item.businessId!);
      }
      if (item.itemType == FavoriteCategoryEnum.service.name &&
          item.workshopId != null) {
        rememberServiceWorkshop(
          serviceId: item.itemId,
          workshopId: item.workshopId!,
          workshopName: item.workshopName,
        );
      }
    }
  }

  void _removeFromCache(String itemType, int itemId) {
    _favoriteIdsByType[itemType]?.remove(itemId);
    _cachedFavorites.removeWhere(
      (item) => item.itemId == itemId && item.itemType == itemType,
    );
  }

  void _emitListUpdate() {
    _emitFavoriteCacheChanged();
    _restoreListState();
  }

  void _emitActionFeedback(String message, {required bool isError}) {
    if (isError) {
      emit(FavoriteActionError(message));
    } else {
      emit(FavoriteActionSuccess(message));
    }
    _restoreListState();
  }

  void _restoreListState() {
    emit(
      FavoritesSuccess(
        items: List.from(_cachedFavorites),
        category: _currentCategory,
      ),
    );
  }

  Future<void> _refreshCurrentCategorySilently() async {
    final result = await repository.getFavorites(_currentCategory);
    result.fold((_) {}, (items) {
      _cachedFavorites = items;
      _favoriteIdsByType[_currentCategory] = items
          .map((item) => item.itemId)
          .toSet();
      _cacheFavoriteMetadata(items);
      emit(FavoritesSuccess(items: items, category: _currentCategory));
    });
  }
}
