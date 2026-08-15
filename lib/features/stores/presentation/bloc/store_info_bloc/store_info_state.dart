part of 'store_info_bloc.dart';

@immutable
class StoreInfoState extends Equatable {
  /// Index of the currently selected category chip (0-based).
  final int selectedCategoryIndex;

  const StoreInfoState({
    this.selectedCategoryIndex = 0,
  });

  StoreInfoState copyWith({
    int? selectedCategoryIndex,
  }) {
    return StoreInfoState(
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }

  @override
  List<Object?> get props => [selectedCategoryIndex];
}
