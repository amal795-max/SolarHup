part of 'compare_session_cubit.dart';

enum CompareSlot { first, second }

class CompareSessionState extends Equatable {
  final CompareProduct? firstProduct;
  final CompareProduct? secondProduct;
  final bool isLoading;
  final String? errorMessage;

  const CompareSessionState({
    this.firstProduct,
    this.secondProduct,
    this.isLoading = false,
    this.errorMessage,
  });

  String? get lockedCategory =>
      firstProduct?.category ?? secondProduct?.category;

  int get selectedCount =>
      (firstProduct != null ? 1 : 0) + (secondProduct != null ? 1 : 0);

  bool get isReadyForComparison =>
      firstProduct != null && secondProduct != null;

  bool containsProduct({
    required int businessId,
    required String productId,
  }) {
    bool matches(CompareProduct? product) =>
        product != null &&
        product.businessId == businessId &&
        product.productId == productId;

    return matches(firstProduct) || matches(secondProduct);
  }

  CompareSlot? slotForProduct({
    required int businessId,
    required String productId,
  }) {
    if (firstProduct != null &&
        firstProduct!.businessId == businessId &&
        firstProduct!.productId == productId) {
      return CompareSlot.first;
    }
    if (secondProduct != null &&
        secondProduct!.businessId == businessId &&
        secondProduct!.productId == productId) {
      return CompareSlot.second;
    }
    return null;
  }

  CompareSessionState copyWith({
    CompareProduct? firstProduct,
    CompareProduct? secondProduct,
    bool? isLoading,
    String? errorMessage,
    bool clearFirst = false,
    bool clearSecond = false,
    bool clearError = false,
  }) {
    return CompareSessionState(
      firstProduct: clearFirst ? null : firstProduct ?? this.firstProduct,
      secondProduct: clearSecond ? null : secondProduct ?? this.secondProduct,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        firstProduct,
        secondProduct,
        isLoading,
        errorMessage,
      ];
}
