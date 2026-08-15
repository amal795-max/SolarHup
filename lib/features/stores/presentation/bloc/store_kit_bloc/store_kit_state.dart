part of 'store_kit_bloc.dart';

class StoreKitState extends Equatable {
  final int selectedCategoryIndex;
  final String searchQuery;

  const StoreKitState({
    this.selectedCategoryIndex = 0,
    this.searchQuery = '',
  });

  StoreKitState copyWith({
    int? selectedCategoryIndex,
    String? searchQuery,
  }) {
    return StoreKitState(
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [selectedCategoryIndex, searchQuery];
}
