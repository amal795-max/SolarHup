part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailInitial extends ProductDetailState {}

final class ProductDetailLoading extends ProductDetailState {}

final class ProductDetailLoaded extends ProductDetailState {
  final ProductDetailModel product;
  final int selectedImageIndex;
  final bool isAddingToCart;
  final bool addedToCart;

  const ProductDetailLoaded({
    required this.product,
    required this.selectedImageIndex,
    this.isAddingToCart = false,
    this.addedToCart = false,
  });

  ProductDetailLoaded copyWith({
    ProductDetailModel? product,
    int? selectedImageIndex,
    bool? isAddingToCart,
    bool? addedToCart,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      addedToCart: addedToCart ?? this.addedToCart,
    );
  }

  @override
  List<Object?> get props =>
      [product, selectedImageIndex, isAddingToCart, addedToCart];
}

final class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
