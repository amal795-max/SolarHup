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
  final List<StoreCategoryModel> categories;
  final List<StoreProductModel> products;
  final List<DiscountedProductModel> discountedProducts;
  final List<DiscountModel> discounts;

  const StoreDetailLoaded({
    required this.store,
    required this.categories,
    required this.products,
    this.discountedProducts = const [],
    this.discounts = const [],
  });

  @override
  List<Object?> get props =>
      [store, categories, products, discountedProducts, discounts];
}

final class StoreDetailError extends StoreDetailState {
  final String message;

  const StoreDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
