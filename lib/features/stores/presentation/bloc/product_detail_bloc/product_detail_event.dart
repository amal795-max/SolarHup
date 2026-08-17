part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProductDetailEvent extends ProductDetailEvent {
  final int businessId;
  final String productId;
  final bool showLoading;

  const LoadProductDetailEvent({
    required this.businessId,
    required this.productId,
    this.showLoading = false,
  });

  @override
  List<Object?> get props => [businessId, productId, showLoading];
}

final class SelectGalleryImageEvent extends ProductDetailEvent {
  final int index;

  const SelectGalleryImageEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

final class AddProductToCartEvent extends ProductDetailEvent {
  const AddProductToCartEvent();
}
