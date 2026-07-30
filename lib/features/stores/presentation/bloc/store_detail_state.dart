part of 'store_detail_cubit.dart';

@immutable
sealed class StoreDetailState extends Equatable {
  const StoreDetailState();

  @override
  List<Object?> get props => [];
}

final class StoreDetailInitial extends StoreDetailState {}

final class StoreDetailLoading extends StoreDetailState {}

final class StoreDetailLoaded extends StoreDetailState {
  final StoreDetailModel store;

  const StoreDetailLoaded({required this.store});

  @override
  List<Object?> get props => [store];
}

final class StoreDetailError extends StoreDetailState {
  final String message;

  const StoreDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
