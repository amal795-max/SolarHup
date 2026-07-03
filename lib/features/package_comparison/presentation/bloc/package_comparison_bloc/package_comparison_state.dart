part of 'package_comparison_bloc.dart';

sealed class PackageComparisonState extends Equatable {
  const PackageComparisonState();

  @override
  List<Object?> get props => [];
}

final class PackageComparisonInitial extends PackageComparisonState {}

final class PackageComparisonLoading extends PackageComparisonState {}

final class PackageComparisonLoaded extends PackageComparisonState {
  final PackageComparisonModel comparison;
  final bool isAddingToCart;
  final String? addingPackageId;
  final String? cartMessage;

  const PackageComparisonLoaded({
    required this.comparison,
    this.isAddingToCart = false,
    this.addingPackageId,
    this.cartMessage,
  });

  PackageComparisonLoaded copyWith({
    PackageComparisonModel? comparison,
    bool? isAddingToCart,
    String? addingPackageId,
    String? cartMessage,
  }) {
    return PackageComparisonLoaded(
      comparison: comparison ?? this.comparison,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      addingPackageId: addingPackageId,
      cartMessage: cartMessage,
    );
  }

  @override
  List<Object?> get props => [
        comparison,
        isAddingToCart,
        addingPackageId,
        cartMessage,
      ];
}

final class PackageComparisonError extends PackageComparisonState {
  final String message;

  const PackageComparisonError({required this.message});

  @override
  List<Object?> get props => [message];
}
