part of 'store_kit_cubit.dart';

@immutable
sealed class StoreKitCubitState extends Equatable {
  const StoreKitCubitState();

  @override
  List<Object?> get props => [];
}

final class StoreKitCubitInitial extends StoreKitCubitState {}

final class StoreKitCubitLoading extends StoreKitCubitState {}

final class StoreKitCubitLoaded extends StoreKitCubitState {
  final List<StoreCategoryModel> categories;
  final List<StoreProductModel> products;

  const StoreKitCubitLoaded({
    required this.categories,
    required this.products,
  });

  @override
  List<Object?> get props => [categories, products];
}

final class StoreKitCubitError extends StoreKitCubitState {
  final String message;

  const StoreKitCubitError({required this.message});

  @override
  List<Object?> get props => [message];
}
