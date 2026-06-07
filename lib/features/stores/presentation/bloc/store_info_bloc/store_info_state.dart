part of 'store_info_bloc.dart';

@immutable
class StoreInfoState extends Equatable {
  /// Whether the current user is following this store.
  final bool isFollowing;

  /// Index of the currently selected category chip (0-based).
  final int selectedCategoryIndex;

  const StoreInfoState({
    this.isFollowing = false,
    this.selectedCategoryIndex = 0,
  });

  StoreInfoState copyWith({
    bool? isFollowing,
    int? selectedCategoryIndex,
  }) {
    return StoreInfoState(
      isFollowing: isFollowing ?? this.isFollowing,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }

  @override
  List<Object?> get props => [isFollowing, selectedCategoryIndex];
}
