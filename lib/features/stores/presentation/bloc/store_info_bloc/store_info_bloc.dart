import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'store_info_event.dart';
part 'store_info_state.dart';

/// Manages local UI state for the Store Info screen:
///   - active category chip selection
class StoreInfoBloc extends Bloc<StoreInfoEvent, StoreInfoState> {
  StoreInfoBloc() : super(const StoreInfoState()) {
    on<SelectStoreCategoryEvent>(_onSelectCategory);
  }

  void _onSelectCategory(
    SelectStoreCategoryEvent event,
    Emitter<StoreInfoState> emit,
  ) {
    emit(state.copyWith(selectedCategoryIndex: event.index));
  }
}
