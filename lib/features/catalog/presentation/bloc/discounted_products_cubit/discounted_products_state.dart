part of 'discounted_products_cubit.dart';

sealed class DiscountedProductsState extends Equatable {
  const DiscountedProductsState();

  @override
  List<Object?> get props => [];
}

final class DiscountedProductsInitial extends DiscountedProductsState {}

final class DiscountedProductsLoading extends DiscountedProductsState {}

final class DiscountedProductsLoaded extends DiscountedProductsState {
  final List<DiscountedProductModel> products;

  const DiscountedProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

final class DiscountedProductsError extends DiscountedProductsState {
  final String message;

  const DiscountedProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
