import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/constants/app_images.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/data_helper.dart';
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
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import '../../../used_system/data/model/used_product_model.dart';
import '../widgets/home_search_bar.dart';

/// Entry point — provides the HomeBloc and immediately fires LoadHomeDataEvent.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const LoadHomeDataEvent(showLoading: false)),
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
      showPrice: false,
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

  static const List<HomeLayoutModel> _skeletonLayout = [
    HomeLayoutModel(key: 'promotions', order: 1, isActive: true),
    HomeLayoutModel(key: 'tips', order: 2, isActive: true),
    HomeLayoutModel(key: 'best_sellers', order: 3, isActive: true),
    HomeLayoutModel(key: 'blog_highlights', order: 4, isActive: true),
    HomeLayoutModel(key: 'used_systems', order: 5, isActive: true),
  ];

  // ── Model → UI data_source mappers ───────────────────────────────────────────────
  // ── Model → UI data mappers ───────────────────────────────────────────────


  ProductCardData _mapNewOffer(ProductModel m) => ProductCardData(
    id: m.id,
    businessId: m.businessId,
    name: m.name,
    category: m.category,
    badgeText: m.badgeText,
    badgeColor: m.badgeColorValue,
    metaText: m.metaText,
    imageAssetPath: m.image.isNotEmpty ? m.image : null,
    imageUrl: m.imageUrl,
    imagePlaceholderColorValue: m.imagePlaceholderColorValue,
    discountPercent: m.discountPercent,
    iconType: m.iconType,
    showPrice: false,
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
    context.push(
      AppRoutes.usedProductDetailScreen,
      extra: product,
    );
  }




  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (_, curr) => curr is HomeError,
      listener: (context, state) {
        if (state is HomeError) {
          DataHelper.showSnackBar(
            message: state.message,
            context: context,
            color: AppColors.red,
          );
        }
      },
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
              )
          ),
        );
      },
    );
  }


  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeLoading || state is HomeInitial) {
      return _buildScrollable(
        isLoading: true,
        layout: _skeletonLayout,
        tips: const [],
        usedProducts: _skeletonUsedProducts,
        newOffers: _skeletonNewOffers,
        blogPosts: _skeletonBlogs,
      );
    }
    if (state is HomeLoaded) {
      return _buildScrollable(
        layout: state.homeLayout,
        tips: state.tips,
        usedProducts: state.usedProducts,
        newOffers: state.newOffers.map(_mapNewOffer).toList(),
        blogPosts: state.blogPosts.map(_mapBlog).toList(),
      );
    }
    if (state is HomeError) {
      return _buildErrorBody(context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildScrollable({
    bool isLoading = false,
    required List<HomeLayoutModel> layout,
    required List<TipModel> tips,
    required List<UsedProductModel> usedProducts,
    required List<ProductCardData> newOffers,
    required List<BlogCardData> blogPosts,
  }) {
    final bool isSearching = _searchQuery.isNotEmpty && !isLoading;

    final filteredUsed = isSearching ? _filterUsedProducts(usedProducts) : usedProducts;
    final filteredNew = isSearching ? _filterProducts(newOffers) : newOffers;
    final filteredBlogs = isSearching ? _filterBlogs(blogPosts) : blogPosts;

    final List<ProductCardData> usedProductsMapped = filteredUsed.map(_mapUsedProduct).toList();

    final Map<String, Widget> sectionWidgets = {
      'tips': DidYouKnowBanner(tips: tips),
      'promotions': PromotionProductsSection(
        titleKey: 'home_new_offer',
        products: filteredNew,
        onViewAll: isLoading ? null : _navigateToDiscountedProducts,
        onProductTap: isLoading ? null : (index) => _navigateToProductDetail(filteredNew[index]),
      ), // Replace with PromotionsSection() when available
      'used_systems': UsedProductsSection(
        titleKey: 'home_used_systems',
        products: usedProductsMapped,
        onViewAll: isLoading ? null : _navigateToUsedProducts,
        onProductTap: isLoading ? null : (index) => _navigateToUsedProductDetail(filteredUsed[index]),
      ),
      'best_sellers': const SizedBox.shrink(),
      'blog_highlights': BlogSection(
        blogs: filteredBlogs,
        onBlogTap: isLoading
            ? null
            : (articleId) => context.push(AppRoutes.blogArticleDetail(articleId)),
      ),
    };

    final content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: HomeSearchBar(
              controller: _searchController,
              enabled: !isLoading,
            ),
          ),

          if (!isLoading && !LocalStorage().getData(key: ApiKeys.isVerified, defaultValue: false))
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: VerificationBanner(),
            ),

          if (!isSearching) ...[
             QuickActionsSection(
                 onUsedSystemsTap: () => context.push(AppRoutes.usedProductScreen),
                 onExpertTap: () => context.push(AppRoutes.askExpertScreen),
             ),
            SizedBox(height: 16.h),
          ],

          ...layout
              .where((section) => section.isActive)
              .map((section) {
            final widget = sectionWidgets[section.key];
            if (widget == null) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: widget,
            );
          }).toList(),
        ],
      ),
    );

    return isLoading ? Skeletonizer(enabled: true, child: content) : content;
  }


  Widget _buildErrorBody(BuildContext context) {
    return EmptyWidget(
      icon: Icons.error_outline,
      iconSize: 56,
      iconColor: AppColors.grey,
      title: 'stores_error_title'.tr(),
      subtitle: 'stores_error_subtitle'.tr(),
      action: CustomButton(
        text: 'stores_retry'.tr(),
        icon: Icons.refresh_rounded,
        iconLeft: true,
        onPressed: () =>
            context.read<HomeBloc>().add(const LoadHomeDataEvent()),
        width: 0.5.sw,
      ),
    );
  }
}

