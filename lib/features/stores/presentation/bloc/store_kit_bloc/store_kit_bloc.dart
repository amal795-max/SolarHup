import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'store_kit_event.dart';
part 'store_kit_state.dart';

class StoreKitBloc extends Bloc<StoreKitEvent, StoreKitState> {
  StoreKitBloc() : super(const StoreKitState()) {
    on<SelectStoreKitCategoryEvent>(_onSelectCategory);
    on<UpdateStoreKitSearchQueryEvent>(_onUpdateSearchQuery);
    on<ToggleStoreKitFavoriteEvent>(_onToggleFavorite);
  }

  void _onSelectCategory(
    SelectStoreKitCategoryEvent event,
    Emitter<StoreKitState> emit,
  ) {
    emit(state.copyWith(selectedCategoryIndex: event.index));
  }

  void _onUpdateSearchQuery(
    UpdateStoreKitSearchQueryEvent event,
    Emitter<StoreKitState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query.trim().toLowerCase()));
  }

  void _onToggleFavorite(
    ToggleStoreKitFavoriteEvent event,
    Emitter<StoreKitState> emit,
  ) {
    final updated = Set<String>.from(state.favoriteProductIds);
    if (updated.contains(event.productId)) {
      updated.remove(event.productId);
    } else {
      updated.add(event.productId);
    }
    emit(state.copyWith(favoriteProductIds: updated));
  }
}
