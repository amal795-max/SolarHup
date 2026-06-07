import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/home/presentation/widgets/home_app_bar.dart';
import 'package:untitled1/features/stores/data/data_source/stores_remote_data_source.dart';
import 'package:untitled1/features/stores/data/models/store_model.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';
import 'package:untitled1/features/stores/presentation/bloc/stores_bloc/stores_bloc.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_card.dart';
import 'package:untitled1/features/stores/presentation/widgets/stores_header_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/stores_search_bar.dart';

/// Entry point — provides StoresBloc and fires the first load immediately.
class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoresBloc(
        StoresRepositoryImpl(
          remote: const StoresRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(const LoadStoresEvent(showLoading: false)),
      child: const _StoresView(),
    );
  }
}

// ---------------------------------------------------------------------------
// Private stateful view — owns search state and nav index
// ---------------------------------------------------------------------------

class _StoresView extends StatefulWidget {
  const _StoresView();

  @override
  State<_StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends State<_StoresView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentNavIndex = 1; // "Store" tab is active

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      if (q != _searchQuery) setState(() => _searchQuery = q);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Skeleton mock data (shown while bloc is in loading state) ─────────────

  static final List<StoreCardData> _skeletonStores = List.generate(
    3,
    (_) => const StoreCardData(
      id: '',
      name: 'Loading Store Name Here',
      location: 'Loading city and state location',
      rating: 4.5,
      tags: ['Tag Label', 'Tag Label'],
      iconData: Icons.bolt,
      iconColorValue: 0xFF0A2A43,
      imagePlaceholderColorValue: 0xFF1A3A5C,
    ),
  );

  // ── Data mapping (StoreModel → StoreCardData) ─────────────────────────────

  StoreCardData _mapStore(StoreModel m) => StoreCardData(
        id: m.id,
        name: m.name,
        location: m.location,
        rating: m.rating,
        tags: m.tags,
        iconData: _iconForType(m.iconType),
        iconColorValue: m.iconColorValue,
        imagePlaceholderColorValue: m.imagePlaceholderColorValue,
        imageUrl: m.imageUrl,
      );

  IconData _iconForType(String type) => switch (type) {
        'sun' => Icons.wb_sunny_rounded,
        'eco' => Icons.eco_rounded,
        _ => Icons.bolt_rounded,
      };

  // ── Search filtering ──────────────────────────────────────────────────────

  List<StoreCardData> _filter(List<StoreCardData> stores) {
    if (_searchQuery.isEmpty) return stores;
    return stores.where((s) {
      return s.name.toLowerCase().contains(_searchQuery) ||
          s.location.toLowerCase().contains(_searchQuery) ||
          s.tags.any((t) => t.toLowerCase().contains(_searchQuery));
    }).toList();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    switch (index) {
      case 0:
        // StoresScreen was pushed on top of HomeScreen — pop back to it
        // so HomeScreen is reused with its nav correctly at index 0.
        context.pop();
      case 2:
        break; // TODO: Services screen
      case 3:
        break; // TODO: Orders screen
    }
  }

  void _onStoreTap(StoreCardData store) {
    // TODO: Navigate to store detail screen
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoresBloc, StoresState>(
      listenWhen: (_, curr) => curr is StoresError,
      listener: (context, state) {
        if (state is StoresError) {
          DataHelper.showSnackBar(
            message: state.message,
            context: context,
            color: AppColors.red,
          );
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: HomeAppBar(onMenuTap: () {}, onCartTap: () {}),
        body: _buildBody(context, state),
        bottomNavigationBar: _StoresBottomNav(
          currentIndex: _currentNavIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }

  // ── Body dispatch ─────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context, StoresState state) {
    // Skeleton is only shown for an explicit StoresLoading state,
    // which is emitted only when showLoading: true — reserved for
    // when a real backend is wired up.
    if (state is StoresLoading) {
      return _buildScrollable(isLoading: true, stores: _skeletonStores);
    }
    if (state is StoresLoaded) {
      return _buildScrollable(
        stores: state.stores.map(_mapStore).toList(),
      );
    }
    if (state is StoresError) {
      return _buildErrorBody(context);
    }
    // StoresInitial: BLoC is already fetching — render empty scaffold
    // so the transition to StoresLoaded is instant with no flicker.
    return const SizedBox.shrink();
  }

  // ── Scrollable content ────────────────────────────────────────────────────

  Widget _buildScrollable({
    bool isLoading = false,
    required List<StoreCardData> stores,
  }) {
    final isSearching = _searchQuery.isNotEmpty && !isLoading;
    final filtered = isSearching ? _filter(stores) : stores;
    final hasNoResults = isSearching && filtered.isEmpty;

    final content = CustomScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        // Fixed header + search bar
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              const StoresHeaderSection(),
              SizedBox(height: 14.h),
              StoresSearchBar(
                controller: _searchController,
                enabled: !isLoading,
                onChanged: (v) =>
                    setState(() => _searchQuery = v.trim().toLowerCase()),
                onClear: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                onFilterTap: () {
                  // TODO: Push to filter screen
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
        // Empty-state or list of store cards
        if (hasNoResults)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildNoResultsBody(),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => StoreCard(
                data: filtered[i],
                onTap: isLoading ? null : () => _onStoreTap(filtered[i]),
              ),
              childCount: filtered.length,
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
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

  // ── Empty / error bodies ──────────────────────────────────────────────────

  Widget _buildNoResultsBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 52.sp,
              color: AppColors.borderColor,
            ),
            SizedBox(height: 16.h),
            Text(
              'stores_no_results'.tr(),
              style: AppStyle.bodySmall.copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              'stores_no_results_hint'.tr(),
              style: AppStyle.labelXSmall.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 56.sp, color: AppColors.grey),
            SizedBox(height: 16.h),
            Text(
              'stores_error_title'.tr(),
              style: AppStyle.h6.copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'stores_error_subtitle'.tr(),
              style: AppStyle.bodyXSmall.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<StoresBloc>().add(const LoadStoresEvent()),
              icon: const Icon(Icons.refresh_rounded),
              label: Text('stores_retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom navigation bar (Store tab is active at index 1)
// ---------------------------------------------------------------------------

class _StoresBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _StoresBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DataHelper.isDarkTheme(context);

    final items = <_NavItem>[
      _NavItem('nav_home'.tr(), Icons.home_outlined, Icons.home),
      _NavItem('nav_store'.tr(), Icons.storefront_outlined, Icons.storefront),
      _NavItem('nav_services'.tr(), Icons.build_outlined, Icons.build),
      _NavItem(
          'nav_orders'.tr(), Icons.receipt_long_outlined, Icons.receipt_long),
    ];

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBottomNav : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkGray : AppColors.borderColor,
          ),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
      ),
      // InkWell is used for each nav item since tapping triggers navigation.
      child: Row(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isActive = currentIndex == idx;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(idx),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive ? item.activeIcon : item.icon,
                    color:
                        isActive ? AppColors.primaryColor : AppColors.grey,
                    size: 22.sp,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    item.label,
                    style: AppStyle.labelXSmall.copyWith(
                      color:
                          isActive ? AppColors.primaryColor : AppColors.grey,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem(this.label, this.icon, this.activeIcon);
}
