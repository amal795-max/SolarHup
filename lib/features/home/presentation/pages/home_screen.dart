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
import 'package:untitled1/features/home/data/models/product_model.dart';
import 'package:untitled1/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:untitled1/features/home/presentation/widgets/blog_card.dart';
import 'package:untitled1/features/home/presentation/widgets/blog_section.dart';
import 'package:untitled1/features/home/presentation/widgets/did_you_know_banner.dart';
import 'package:untitled1/features/home/presentation/widgets/home_app_bar.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/home/presentation/widgets/products_section.dart';
import 'package:untitled1/features/home/presentation/widgets/quick_actions_section.dart';
import 'package:untitled1/features/home/presentation/widgets/solar_dynamic_background.dart';
import 'package:untitled1/features/home/presentation/widgets/verification_banner.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';

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

  List<BlogCardData> _filterBlogs(List<BlogCardData> blogs) {
    if (_searchQuery.isEmpty) return blogs;
    return blogs.where((b) {
      return b.title.toLowerCase().contains(_searchQuery) ||
          b.meta.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  // ── Skeleton mock data_source (shown while HomeLoading) ──────────────────────────

  static final List<ProductCardData> _skeletonProducts = List.generate(
    3,
    (i) => const ProductCardData(
      name: 'Loading Product Name',
      price: 149.00,
      imagePlaceholderColorValue: 0xFF0A2A43,
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

  // ── Model → UI data_source mappers ───────────────────────────────────────────────
  // ── Model → UI data mappers ───────────────────────────────────────────────

  ProductCardData _mapProduct(ProductModel m) => ProductCardData(
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
  );

  BlogCardData _mapBlog(BlogModel m) => BlogCardData(
    id: m.id,
    title: m.title,
    meta: m.meta,
    imagePlaceholderColorValue: m.imagePlaceholderColorValue,
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
            appBar: HomeAppBar(onMenuTap: () {
              // context.push(AppRoutes.settingsScreen);
            },
                onCartTap: () {
              context.push(AppRoutes.cartScreen);
            }),
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
        usedProducts: _skeletonProducts,
        newOffers: _skeletonProducts,
        blogPosts: _skeletonBlogs,
      );
    }
    if (state is HomeLoaded) {
      return _buildScrollable(
        usedProducts: state.usedProducts.map(_mapProduct).toList(),
        newOffers: state.newOffers.map(_mapProduct).toList(),
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
    required List<ProductCardData> usedProducts,
    required List<ProductCardData> newOffers,
    required List<BlogCardData> blogPosts,
  }) {
    final bool isSearching = _searchQuery.isNotEmpty && !isLoading;

    final filteredUsed = isSearching
        ? _filterProducts(usedProducts)
        : usedProducts;
    final filteredNew = isSearching ? _filterProducts(newOffers) : newOffers;
    final filteredBlogs = isSearching ? _filterBlogs(blogPosts) : blogPosts;

    final bool hasNoResults =
        isSearching &&
        filteredUsed.isEmpty &&
        filteredNew.isEmpty &&
        filteredBlogs.isEmpty;

    final content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20),
            child: HomeSearchBar(
              controller: _searchController,
              enabled: !isLoading,
              onChanged: (value) =>
                  setState(() => _searchQuery = value.trim().toLowerCase()),
              onClear: () => setState(() => _searchQuery = ''),
            ),
          ),
          SizedBox(height: 16.h),
          const DidYouKnowBanner(),
          if (!isLoading && !LocalStorage().getData(key: ApiKeys.isVerified, defaultValue: false))

            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: const VerificationBanner(),
            ),
          SizedBox(height: 16.h),
          // Collapse banners + quick actions while actively searching
          if (!isSearching) ...[

            // const UsedSystemBanner(),
            // SizedBox(height: 16.h),
            QuickActionsSection(
              onCalculatorTap: isLoading ? null : () {
                context.push(AppRoutes.bookConsultationScreen);
              },
              onCompareTap: isLoading
                  ? null
                  : () => context.push(AppRoutes.packageComparisonScreen),
            ),
            SizedBox(height: 16.h),


          if (hasNoResults)
            _buildNoResultsBody()
          else ...[
            ProductsSection(
              titleKey: 'home_used_systems',
              products: filteredUsed,
              onViewAll: isLoading ? null : _navigateToUsedProducts,
              onProductTap: isLoading ? null : (_) => _navigateToUsedProducts(),
            ),

            SizedBox(height: 16.h), ],
            ProductsSection(
              titleKey: 'home_new_offer',
              products: filteredNew,
              onViewAll: isLoading ? null : _navigateToDiscountedProducts,
              onProductTap: isLoading
                  ? null
                  : (index) => _navigateToProductDetail(filteredNew[index]),
            ),
            SizedBox(height: 24.h),
            BlogSection(
              blogs: filteredBlogs,
              onBlogTap: isLoading
                  ? null
                  : (articleId) => context.push(
                        AppRoutes.blogArticleDetail(articleId),
                      ),
            ),
          ],
        ],
      ),
    );

    if (isLoading) {

      return Skeletonizer(
        enabled: true,
        effect: const ShimmerEffect(
          baseColor: Color(0xFFE0E0E0),
          highlightColor: Color(0xFFF5F5F5),
        ),
        child: content,
      );
    }
    return content;
  }

  Widget _buildNoResultsBody() {
    return EmptyWidget(
      icon: Icons.search_off_rounded,
      iconSize: 52,
      iconColor: AppColors.borderColor,
      title: 'No results for "$_searchQuery"',
      subtitle: 'Try different keywords or check the spelling.',
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
    );
  }

  Widget _buildErrorBody(BuildContext context) {
    return EmptyWidget(
      icon: Icons.wifi_off_rounded,
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
        width: 160.w,
      ),
    );
  }
}

