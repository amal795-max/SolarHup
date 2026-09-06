import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/constants/app_images.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/home/data/models/blog_model.dart';
import 'package:untitled1/features/home/data/models/home_layout_model.dart';
import 'package:untitled1/features/home/data/models/product_model.dart';
import 'package:untitled1/features/home/data/models/tip_model.dart';
import 'package:untitled1/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:untitled1/features/home/presentation/widgets/blog_card.dart';
import 'package:untitled1/features/home/presentation/widgets/blog_section.dart';
import 'package:untitled1/features/home/presentation/widgets/did_you_know_banner.dart';
import 'package:untitled1/features/home/presentation/widgets/home_app_bar.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/home/presentation/widgets/promotion_product_section.dart';
import 'package:untitled1/features/home/presentation/widgets/used_products_section.dart';
import 'package:untitled1/features/home/presentation/widgets/quick_actions_section.dart';
import 'package:untitled1/features/home/presentation/widgets/solar_dynamic_background.dart';
import 'package:untitled1/features/home/presentation/widgets/verification_banner.dart';
import 'package:untitled1/widgets/animation_widget.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/section_error_widget.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import '../../../used_system/data/model/used_product_model.dart';
import '../bloc/application_cubit.dart';
import '../widgets/home_search_bar.dart';

/// Entry point — provides the HomeBloc and immediately fires LoadHomeDataEvent.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HomeBloc>()..add(const LoadHomeDataEvent(showLoading: false)),
      child: const _HomeView(),
    );
  }
}

// ---------------------------------------------------------------------------
// Private view — reads the bloc from context
// ---------------------------------------------------------------------------

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  // ── Search ────────────────────────────────────────────────────────────────

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      if (q != _searchQuery) {
        setState(() => _searchQuery = q);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductCardData> _filterProducts(List<ProductCardData> products) {
    if (_searchQuery.isEmpty) return products;
    return products.where((p) {
      return p.name.toLowerCase().contains(_searchQuery) ||
          (p.category?.toLowerCase().contains(_searchQuery) ?? false) ||
          (p.metaText?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();
  }

  List<UsedProductModel> _filterUsedProducts(List<UsedProductModel> products) {
    if (_searchQuery.isEmpty) return products;
    return products.where((p) {
      return p.name.toLowerCase().contains(_searchQuery) ||
          p.category.toLowerCase().contains(_searchQuery) ||
          p.region.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  List<BlogCardData> _filterBlogs(List<BlogCardData> blogs) {
    if (_searchQuery.isEmpty) return blogs;
    return blogs.where((b) {
      return b.title.toLowerCase().contains(_searchQuery) ||
          b.meta.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  // ── Skeleton mock data_source (shown while HomeLoading) ──────────────────────────

  static final List<ProductCardData> _skeletonNewOffers = List.generate(
    3,
    (i) => const ProductCardData(
      name: 'Loading Product Name',
      imagePlaceholderColorValue: 0xFF0A2A43,
      showPrice: true,
      price: 0.0,
      category: 'Category',
    ),
  );

  static final List<UsedProductModel> _skeletonUsedProducts = List.generate(
    3,
    (i) => UsedProductModel(
      id: i,
      sellerId: 0,
      sellerPhone: '',
      name: 'Loading Used Product',
      description: '',
      category: 'Category',
      condition: 'Good',
      price: '0.0',
      region: 'Region',
      status: 'active',
      images: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  static final List<BlogCardData> _skeletonBlogs = List.generate(
    2,
    (i) => BlogCardData(
      id: 'blog-$i',
      title: 'Loading blog post title here',
      meta: '5 min read • Category',
      imagePlaceholderColorValue: 0xFF4A7B9D,
    ),
  );

  static const List<HomeLayoutModel> _skeletonLayout =
      HomeLayoutModel.defaultLayout;

  // ── Model → UI data_source mappers ───────────────────────────────────────────────
  // ── Model → UI data mappers ───────────────────────────────────────────────

  ProductCardData _mapNewOffer(ProductModel m) => ProductCardData(
    id: m.id,
    businessId: m.businessId,
    name: m.name,
    category: m.category,
    price: m.price,
    originalPrice: m.originalPrice,
    badgeText: m.badgeText,
    badgeColor: m.badgeColorValue,
    metaText: m.metaText,
    imageAssetPath: m.image.isNotEmpty ? m.image : null,
    imageUrl: m.imageUrl,
    imagePlaceholderColorValue: m.imagePlaceholderColorValue,
    discountPercent: m.discountPercent,
    iconType: m.iconType,
    showPrice: true,
    promotionAlreadyUsed: m.promotionAlreadyUsed,
  );

  ProductCardData _mapUsedProduct(UsedProductModel m) => ProductCardData(
    id: m.id.toString(),
    name: m.name,
    category: m.category,
    price: double.tryParse(m.price) ?? 0.0,
    metaText: m.region,
    imageUrl: m.images.isNotEmpty ? m.images.first : null,
    imagePlaceholderColorValue: 0xFF0A2A43,
  );

  BlogCardData _mapBlog(BlogModel m) => BlogCardData(
    id: m.id,
    title: m.title,
    meta: m.meta,
    imagePlaceholderColorValue: m.imagePlaceholderColorValue,
    imageUrl: m.imageUrl,
    imageIcon: m.iconType == 'finance'
        ? Icons.account_balance_outlined
        : Icons.wb_sunny_outlined,
  );

  void _navigateToUsedProducts() => context.push(AppRoutes.usedProductScreen);

  void _navigateToDiscountedProducts() =>
      context.push(AppRoutes.discountedProductsScreen);

  void _navigateToTopSellingProducts() =>
      context.push(AppRoutes.topSellingProductsScreen);

  void _navigateToProductDetail(ProductCardData product) {
    final businessId = product.businessId;
    final productId = product.id;
    if (businessId == null || productId == null) return;
    context.push(
      AppRoutes.productDetailScreen,
      extra: ProductDetailRouteArgs(
        businessId: businessId,
        productId: productId,
      ),
    );
  }

  void _navigateToUsedProductDetail(UsedProductModel product) {
    context.push(AppRoutes.usedProductDetailScreen, extra: product);
  }

  Future<void> _refreshHome() async {
    final bloc = context.read<HomeBloc>();
    final startToken = switch (bloc.state) {
      HomeLoaded(:final refreshToken) => refreshToken,
      _ => 0,
    };

    bloc.add(const RefreshHomeDataEvent());
    await bloc.stream.firstWhere(
      (state) => state is HomeLoaded && state.refreshToken > startToken,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SafeArea(
          top: false,
          child: SolarDynamicBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: HomeAppBar(
                onCartTap: () {
                  context.push(AppRoutes.cartScreen);
                },
              ),
              body: _buildBody(context, state),

              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.push(AppRoutes.chatBotScreen);
                },
                backgroundColor: AppColors.secondaryColor,
                elevation: 4,
                shape: const CircleBorder(),
                child: SvgPicture.asset(AppImages.chatBotIcon),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeInitial) {
      return _buildScrollable(
        loadingLayout: true,
        layout: _skeletonLayout,
        loadingTips: true,
        tips: const [],
        loadingUsedProducts: true,
        usedProducts: _skeletonUsedProducts,
        loadingTopSellingProducts: true,
        topSellingProducts: _skeletonNewOffers,
        loadingNewOffers: true,
        newOffers: _skeletonNewOffers,
        loadingBlogPosts: true,
        blogPosts: _skeletonBlogs,
      );
    }
    if (state is HomeLoaded) {
      return _buildScrollable(
        loadingLayout: state.loadingLayout,
        layout: state.homeLayout,
        loadingTips: state.loadingTips,
        tips: state.tips,
        tipsError: state.tipsError,
        loadingUsedProducts: state.loadingUsedProducts,
        usedProducts: state.usedProducts,
        usedProductsError: state.usedProductsError,
        loadingTopSellingProducts: state.loadingTopSellingProducts,
        topSellingProducts: state.topSellingProducts.map(_mapNewOffer).toList(),
        topSellingProductsError: state.topSellingProductsError,
        loadingNewOffers: state.loadingNewOffers,
        newOffers: state.newOffers.map(_mapNewOffer).toList(),
        newOffersError: state.newOffersError,
        loadingBlogPosts: state.loadingBlogPosts,
        blogPosts: state.blogPosts.map(_mapBlog).toList(),
        blogPostsError: state.blogPostsError,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildScrollable({
    bool loadingLayout = false,
    required List<HomeLayoutModel> layout,
    bool loadingTips = false,
    required List<TipModel> tips,
    String? tipsError,
    bool loadingUsedProducts = false,
    required List<UsedProductModel> usedProducts,
    String? usedProductsError,
    bool loadingTopSellingProducts = false,
    required List<ProductCardData> topSellingProducts,
    String? topSellingProductsError,
    bool loadingNewOffers = false,
    required List<ProductCardData> newOffers,
    String? newOffersError,
    bool loadingBlogPosts = false,
    required List<BlogCardData> blogPosts,
    String? blogPostsError,
  }) {
    final bool isSearching = _searchQuery.isNotEmpty;
    final homeBloc = context.read<HomeBloc>();

    VoidCallback? retrySection(String sectionKey) =>
        () => homeBloc.add(RetryHomeSectionEvent(sectionKey));

    final filteredUsed = isSearching
        ? _filterUsedProducts(usedProducts)
        : usedProducts;
    final filteredTopSelling = isSearching
        ? _filterProducts(topSellingProducts)
        : topSellingProducts;
    final filteredNew = isSearching ? _filterProducts(newOffers) : newOffers;
    final filteredBlogs = isSearching ? _filterBlogs(blogPosts) : blogPosts;

    final List<ProductCardData> usedProductsMapped = filteredUsed
        .map(_mapUsedProduct)
        .toList();

    final Map<String, Widget> sectionWidgets = {
      'tips': AnimationWidget(
        child: Skeletonizer(
          enabled: loadingTips,
          child: tipsError != null
              ? SectionErrorWidget(
                  message: tipsError,
                  onRetry: retrySection('tips'),
                )
              : DidYouKnowBanner(tips: tips),
        ),
      ),
      if (filteredNew.isNotEmpty)
        'promotions': AnimationWidget(
          child: Skeletonizer(
            enabled: loadingNewOffers,
            child: PromotionProductsSection(
              titleKey: 'home_new_offer',
              products: loadingNewOffers ? _skeletonNewOffers : filteredNew,
              errorMessage: newOffersError,
              onRetry: retrySection('promotions'),
              onViewAll: loadingNewOffers
                  ? null
                  : _navigateToDiscountedProducts,
              onProductTap: loadingNewOffers
                  ? null
                  : (index) => _navigateToProductDetail(filteredNew[index]),
            ),
          ),
        ),
      if (usedProductsMapped.isNotEmpty)
        'used_systems': AnimationWidget(
          child: Skeletonizer(
            enabled: loadingUsedProducts,
            child: AnimationWidget(
              child: UsedProductsSection(
                titleKey: 'home_used_systems',
                products: loadingUsedProducts
                    ? _skeletonUsedProducts.map(_mapUsedProduct).toList()
                    : usedProductsMapped,
                errorMessage: usedProductsError,
                onRetry: retrySection('used_systems'),
                onViewAll: loadingUsedProducts ? null : _navigateToUsedProducts,
                onProductTap: loadingUsedProducts
                    ? null
                    : (index) =>
                          _navigateToUsedProductDetail(filteredUsed[index]),
              ),
            ),
          ),
        ),
      if (filteredTopSelling.isNotEmpty)
        'best_sellers': Skeletonizer(
          enabled: loadingTopSellingProducts,
          child: AnimationWidget(
            child: PromotionProductsSection(
              titleKey: 'top_selling',
              products: loadingTopSellingProducts
                  ? _skeletonNewOffers
                  : filteredTopSelling,
              errorMessage: topSellingProductsError,
              onRetry: retrySection('best_sellers'),
              onViewAll: loadingTopSellingProducts
                  ? null
                  : _navigateToTopSellingProducts,
              onProductTap: loadingTopSellingProducts
                  ? null
                  : (index) =>
                        _navigateToProductDetail(filteredTopSelling[index]),
            ),
          ),
        ),
      if (filteredBlogs.isNotEmpty)
        'blog_highlights': AnimationWidget(
          child: Skeletonizer(
            enabled: loadingBlogPosts,
            child: BlogSection(
              blogs: loadingBlogPosts ? _skeletonBlogs : filteredBlogs,
              errorMessage: blogPostsError,
              onRetry: retrySection('blog_highlights'),
              onBlogTap: loadingBlogPosts
                  ? null
                  : (articleId) =>
                        context.push(AppRoutes.blogArticleDetail(articleId)),
            ),
          ),
        ),
    };

    return BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, appState) {
        final bool isVerified =LocalStorage().getData(key: ApiKeys.isVerified);
        return AppRefreshIndicator(
          onRefresh: _refreshHome,
          child: SingleChildScrollView(
            physics: appRefreshPhysics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: HomeSearchBar(controller: _searchController),
                ),
                if (!loadingLayout && !isVerified)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: VerificationBanner(),
                  ),
                if (!isSearching) ...[
                  AnimationWidget(
                    child: QuickActionsSection(
                      onUsedSystemsTap: () =>
                          context.push(AppRoutes.usedProductScreen),
                      onExpertTap: () => context.push(AppRoutes.askExpertScreen),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
                Skeletonizer(
                  enabled: loadingLayout,
                  child: Column(
                    children: layout.where((section) => section.isActive).map((
                      section,
                    ) {
                      final widget = sectionWidgets[section.key];
                      if (widget == null) return const SizedBox.shrink();

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: widget,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
