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
  final bool loadingUsedProducts;
  final List<ProductModel> topSellingProducts;
  final String? topSellingProductsError;
  final bool loadingTopSellingProducts;
  final List<ProductModel> newOffers;
  final String? newOffersError;
  final bool loadingNewOffers;
  final List<BlogModel> blogPosts;
  final String? blogPostsError;
  final bool loadingBlogPosts;
  final List<TipModel> tips;
  final String? tipsError;
  final bool loadingTips;
  final List<HomeLayoutModel> homeLayout;
  final bool loadingLayout;
  final int refreshToken;

  const HomeLoaded({
    required this.usedProducts,
    this.usedProductsError,
    this.loadingUsedProducts = false,
    required this.topSellingProducts,
    this.topSellingProductsError,
    this.loadingTopSellingProducts = false,
    required this.newOffers,
    this.newOffersError,
    this.loadingNewOffers = false,
    required this.blogPosts,
    this.blogPostsError,
    this.loadingBlogPosts = false,
    this.tips = const [],
    this.tipsError,
    this.loadingTips = false,
    required this.homeLayout,
    this.loadingLayout = false,
    this.refreshToken = 0,
  });

  HomeLoaded copyWith({
    List<UsedProductModel>? usedProducts,
    String? usedProductsError,
    bool? loadingUsedProducts,
    bool clearUsedProductsError = false,
    List<ProductModel>? topSellingProducts,
    String? topSellingProductsError,
    bool? loadingTopSellingProducts,
    bool clearTopSellingProductsError = false,
    List<ProductModel>? newOffers,
    String? newOffersError,
    bool? loadingNewOffers,
    bool clearNewOffersError = false,
    List<BlogModel>? blogPosts,
    String? blogPostsError,
    bool? loadingBlogPosts,
    bool clearBlogPostsError = false,
    List<TipModel>? tips,
    String? tipsError,
    bool? loadingTips,
    bool clearTipsError = false,
    List<HomeLayoutModel>? homeLayout,
    bool? loadingLayout,
    int? refreshToken,
  }) {
    return HomeLoaded(
      usedProducts: usedProducts ?? this.usedProducts,
      usedProductsError: clearUsedProductsError
          ? null
          : (usedProductsError ?? this.usedProductsError),
      loadingUsedProducts: loadingUsedProducts ?? this.loadingUsedProducts,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      topSellingProductsError: clearTopSellingProductsError
          ? null
          : (topSellingProductsError ?? this.topSellingProductsError),
      loadingTopSellingProducts:
          loadingTopSellingProducts ?? this.loadingTopSellingProducts,
      newOffers: newOffers ?? this.newOffers,
      newOffersError:
          clearNewOffersError ? null : (newOffersError ?? this.newOffersError),
      loadingNewOffers: loadingNewOffers ?? this.loadingNewOffers,
      blogPosts: blogPosts ?? this.blogPosts,
      blogPostsError:
          clearBlogPostsError ? null : (blogPostsError ?? this.blogPostsError),
      loadingBlogPosts: loadingBlogPosts ?? this.loadingBlogPosts,
      tips: tips ?? this.tips,
      tipsError: clearTipsError ? null : (tipsError ?? this.tipsError),
      loadingTips: loadingTips ?? this.loadingTips,
      homeLayout: homeLayout ?? this.homeLayout,
      loadingLayout: loadingLayout ?? this.loadingLayout,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [
        usedProducts,
        usedProductsError,
        loadingUsedProducts,
        topSellingProducts,
        topSellingProductsError,
        loadingTopSellingProducts,
        newOffers,
        newOffersError,
        loadingNewOffers,
        blogPosts,
        blogPostsError,
        loadingBlogPosts,
        tips,
        tipsError,
        loadingTips,
        homeLayout,
        loadingLayout,
        refreshToken,
      ];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
