part of 'top_selling_products_cubit.dart';

sealed class TopSellingProductsState extends Equatable {
  const TopSellingProductsState();

  @override
  List<Object?> get props => [];
}

final class TopSellingProductsInitial extends TopSellingProductsState {}

final class TopSellingProductsLoading extends TopSellingProductsState {}

final class TopSellingProductsLoaded extends TopSellingProductsState {
  final List<ProductModel> products;

  const TopSellingProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

final class TopSellingProductsError extends TopSellingProductsState {
  final String message;

  const TopSellingProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
