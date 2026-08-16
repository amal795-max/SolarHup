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
  final String? usedProductsError;
  final List<ProductModel> topSellingProducts;
  final String? topSellingProductsError;
  final List<ProductModel> newOffers;
  final String? newOffersError;
  final List<BlogModel> blogPosts;
  final String? blogPostsError;
  final List<TipModel> tips;
  final String? tipsError;
  final List<HomeLayoutModel> homeLayout;
  final int refreshToken;

  const HomeLoaded({
    required this.usedProducts,
    this.usedProductsError,
    required this.topSellingProducts,
    this.topSellingProductsError,
    required this.newOffers,
    this.newOffersError,
    required this.blogPosts,
    this.blogPostsError,
    this.tips = const [],
    this.tipsError,
    required this.homeLayout,
    this.refreshToken = 0,
  });

  HomeLoaded copyWith({
    List<UsedProductModel>? usedProducts,
    String? usedProductsError,
    bool clearUsedProductsError = false,
    List<ProductModel>? topSellingProducts,
    String? topSellingProductsError,
    bool clearTopSellingProductsError = false,
    List<ProductModel>? newOffers,
    String? newOffersError,
    bool clearNewOffersError = false,
    List<BlogModel>? blogPosts,
    String? blogPostsError,
    bool clearBlogPostsError = false,
    List<TipModel>? tips,
    String? tipsError,
    bool clearTipsError = false,
    List<HomeLayoutModel>? homeLayout,
    int? refreshToken,
  }) {
    return HomeLoaded(
      usedProducts: usedProducts ?? this.usedProducts,
      usedProductsError: clearUsedProductsError
          ? null
          : (usedProductsError ?? this.usedProductsError),
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      topSellingProductsError: clearTopSellingProductsError
          ? null
          : (topSellingProductsError ?? this.topSellingProductsError),
      newOffers: newOffers ?? this.newOffers,
      newOffersError:
          clearNewOffersError ? null : (newOffersError ?? this.newOffersError),
      blogPosts: blogPosts ?? this.blogPosts,
      blogPostsError:
          clearBlogPostsError ? null : (blogPostsError ?? this.blogPostsError),
      tips: tips ?? this.tips,
      tipsError: clearTipsError ? null : (tipsError ?? this.tipsError),
      homeLayout: homeLayout ?? this.homeLayout,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [
        usedProducts,
        usedProductsError,
        topSellingProducts,
        topSellingProductsError,
        newOffers,
        newOffersError,
        blogPosts,
        blogPostsError,
        tips,
        tipsError,
        homeLayout,
        refreshToken,
      ];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
