part of 'store_kit_bloc.dart';

class StoreKitState extends Equatable {
  final int selectedCategoryIndex;
  final String searchQuery;
  final Set<String> favoriteProductIds;

  const StoreKitState({
    this.selectedCategoryIndex = 0,
    this.searchQuery = '',
    this.favoriteProductIds = const {},
  });

  StoreKitState copyWith({
    int? selectedCategoryIndex,
    String? searchQuery,
    Set<String>? favoriteProductIds,
  }) {
    return StoreKitState(
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
    );
  }

  bool isFavorite(String productId) => favoriteProductIds.contains(productId);

  @override
  List<Object?> get props => [selectedCategoryIndex, searchQuery, favoriteProductIds];
}
