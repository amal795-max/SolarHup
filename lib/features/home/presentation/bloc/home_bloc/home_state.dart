part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<ProductModel> usedProducts;
  final List<ProductModel> newOffers;
  final List<BlogModel> blogPosts;
  final List<TipModel> tips;

  const HomeLoaded({
    required this.usedProducts,
    required this.newOffers,
    required this.blogPosts,
    this.tips = const [],
  });

  @override
  List<Object?> get props => [usedProducts, newOffers, blogPosts, tips];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
