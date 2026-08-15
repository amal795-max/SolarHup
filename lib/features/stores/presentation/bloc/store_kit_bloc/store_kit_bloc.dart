import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'store_kit_event.dart';
part 'store_kit_state.dart';

class StoreKitBloc extends Bloc<StoreKitEvent, StoreKitState> {
  StoreKitBloc() : super(const StoreKitState()) {
    on<SelectStoreKitCategoryEvent>(_onSelectCategory);
    on<UpdateStoreKitSearchQueryEvent>(_onUpdateSearchQuery);
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
}
