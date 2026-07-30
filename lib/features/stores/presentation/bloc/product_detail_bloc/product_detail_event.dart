part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProductDetailEvent extends ProductDetailEvent {
  final String businessId;
  final String productId;

  const LoadProductDetailEvent({
    required this.businessId,
    required this.productId,
  });

  @override
  List<Object?> get props => [businessId, productId];
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
