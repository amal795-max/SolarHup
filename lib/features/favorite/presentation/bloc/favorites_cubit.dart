import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/constants/failure_success_message.dart';
import 'package:untitled1/features/favorite/data/models/favorite_model.dart';
import 'package:untitled1/features/favorite/domain/repositories/favorite_repository.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/enums/favorite_category_enum.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteRepository repository;
  List<FavoriteModel> _cachedFavorites = [];
  String _currentCategory = FavoriteCategoryEnum.product.name;

  FavoritesCubit(this.repository) : super(FavoritesInitial());

  Future<void> loadFavorites(String category) async {
    _currentCategory = category;
    emit(FavoritesLoading(category));
    final result = await repository.getFavorites(category);

    result.fold(
      (failure) => emit(FavoritesError(failure.message, category)),
      (items) {
        _cachedFavorites = items;
        emit(FavoritesSuccess(items: items, category: category));
      },
    );
  }

  Future<void> addFavorite(String itemType, int itemId) async {
    emit(FavoriteActionLoading());
    final result = await repository.addFavorite(itemType, itemId);
    
    result.fold(
      (failure) => emit(FavoriteActionError(mapFailureToMessage(failure))),
      (_) async {
        if (itemType == _currentCategory) {
          await loadFavorites(_currentCategory);
        }
        emit(const FavoriteActionSuccess(addedToFavoriteSuccessfully));
      },
    );
  }

  Future<void> deleteFavorite(String itemType, int itemId) async {
    emit(FavoriteActionLoading());
    final result = await repository.deleteFavorite(itemType, itemId);

    result.fold(
      (failure) => emit(FavoriteActionError(mapFailureToMessage(failure))),
      (_) {
        _cachedFavorites.removeWhere((item) => item.itemId == itemId && item.itemType == itemType);
        emit(FavoritesSuccess(items: List.from(_cachedFavorites), category: _currentCategory));
        emit(const FavoriteActionSuccess(deleteFavoriteSuccessfully));
      },
    );
  }

  Future<void> toggleFavorite(String itemType, int itemId) async {
    final isFav = isFavorite(itemType, itemId);
    if (isFav) {
      await deleteFavorite(itemType, itemId);
    } else {
      await addFavorite(itemType, itemId);
    }
  }

  bool isFavorite(String itemType, int itemId) {
    return _cachedFavorites.any((e) => e.itemId == itemId && e.itemType == itemType);
  }
}
