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
  final List<UsedProductModel> usedProducts;
  final List<UsedProductModel> topSellingProducts;
  final List<ProductModel> newOffers;
  final List<BlogModel> blogPosts;
  final List<TipModel> tips;
  final List<HomeLayoutModel> homeLayout;


  const HomeLoaded({
    required this.usedProducts,
    required this.topSellingProducts,
    required this.newOffers,
    required this.blogPosts,
    this.tips = const [], required this.homeLayout,
  });

  @override
  List<Object?> get props => [usedProducts, topSellingProducts, newOffers, blogPosts, tips, homeLayout];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
