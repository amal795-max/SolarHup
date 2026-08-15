import 'package:equatable/equatable.dart';
import 'package:untitled1/features/favorite/data/models/favorite_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {
  final String category;
  const FavoritesLoading(this.category);

  @override
  List<Object?> get props => [category];
}

class FavoritesSuccess extends FavoritesState {
  final List<FavoriteModel> items;
  final String category;

  const FavoritesSuccess({
    required this.items,
    required this.category,
  });

  @override
  List<Object?> get props => [items, category];

  FavoritesSuccess copyWith({
    List<FavoriteModel>? items,
    String? category,
  }) {
    return FavoritesSuccess(
      items: items ?? this.items,
      category: category ?? this.category,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;
  final String category;

  const FavoritesError(this.message, this.category);

  @override
  List<Object?> get props => [message, category];
}

class FavoriteActionLoading extends FavoritesState {}

class FavoriteActionSuccess extends FavoritesState {
  final String message;
  const FavoriteActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoriteActionError extends FavoritesState {
  final String message;
  const FavoriteActionError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoritesCacheReady extends FavoritesState {
  final int revision;

  const FavoritesCacheReady(this.revision);

  @override
  List<Object?> get props => [revision];
}
