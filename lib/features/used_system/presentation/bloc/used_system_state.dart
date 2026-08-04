part of 'used_system_cubit.dart';

abstract class UsedSystemState extends Equatable {
  const UsedSystemState();

  @override
  List<Object?> get props => [];
}

class UsedSystemInitial extends UsedSystemState {}

class UsedProductsLoading extends UsedSystemState {}

class UsedProductsSuccess extends UsedSystemState {
  final List<UsedProductModel> products;
  const UsedProductsSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

class UsedProductsFailure extends UsedSystemState {
  final String message;
  const UsedProductsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class MyUsedProductsLoading extends UsedSystemState {}

class MyUsedProductsSuccess extends UsedSystemState {
  final List<UsedProductModel> products;
  const MyUsedProductsSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

class MyUsedProductsFailure extends UsedSystemState {
  final String message;
  const MyUsedProductsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AddUsedProductLoading extends UsedSystemState {}
class UploadImage extends UsedSystemState {}

class AddUsedProductSuccess extends UsedSystemState {
  final UsedProductModel product;
  final String message;
  const AddUsedProductSuccess(this.product, this.message);

  @override
  List<Object?> get props => [product];
}

class AddUsedProductFailure extends UsedSystemState {
  final String message;
  const AddUsedProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateProductStatusLoading extends UsedSystemState {
  final int? productId;
  const UpdateProductStatusLoading({this.productId});

  @override
  List<Object?> get props => [productId];
}

class UpdateProductStatusSuccess extends UsedSystemState {
  final String message;
  const UpdateProductStatusSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateProductStatusFailure extends UsedSystemState {
  final String message;
  const UpdateProductStatusFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteProductLoading extends UsedSystemState {
  final int? productId;
  const DeleteProductLoading({this.productId});

  @override
  List<Object?> get props => [productId];
}

class DeleteProductSuccess extends UsedSystemState {
  final String message;
  const DeleteProductSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteProductFailure extends UsedSystemState {
  final String message;
  const DeleteProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateProductLoading extends UsedSystemState {}

class UpdateProductSuccess extends UsedSystemState {
  final String message;
  const UpdateProductSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateProductFailure extends UsedSystemState {
  final String message;
  const UpdateProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}
