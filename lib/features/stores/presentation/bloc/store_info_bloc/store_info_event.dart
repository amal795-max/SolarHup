part of 'store_info_bloc.dart';

@immutable
sealed class StoreInfoEvent extends Equatable {
  const StoreInfoEvent();

  @override
  List<Object?> get props => [];
}

/// Sets the active category chip to [index].
final class SelectStoreCategoryEvent extends StoreInfoEvent {
  final int index;

  const SelectStoreCategoryEvent(this.index);

  @override
  List<Object?> get props => [index];
}
