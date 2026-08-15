part of 'store_kit_bloc.dart';

@immutable
sealed class StoreKitEvent extends Equatable {
  const StoreKitEvent();

  @override
  List<Object?> get props => [];
}

final class SelectStoreKitCategoryEvent extends StoreKitEvent {
  final int index;

  const SelectStoreKitCategoryEvent(this.index);

  @override
  List<Object?> get props => [index];
}

final class UpdateStoreKitSearchQueryEvent extends StoreKitEvent {
  final String query;

  const UpdateStoreKitSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}
