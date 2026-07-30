part of 'stores_cubit.dart';

@immutable
sealed class StoresState extends Equatable {
  const StoresState();

  @override
  List<Object?> get props => [];
}

final class StoresInitial extends StoresState {}

final class StoresLoading extends StoresState {}

final class StoresLoaded extends StoresState {
  final List<StoreModel> stores;

  const StoresLoaded({required this.stores});

  @override
  List<Object?> get props => [stores];
}

final class StoresError extends StoresState {
  final String message;

  const StoresError({required this.message});

  @override
  List<Object?> get props => [message];
}
