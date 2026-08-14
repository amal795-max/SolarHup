import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/product_compare/data/models/compare_product_model.dart';
import 'package:untitled1/features/product_compare/data/repositories/product_compare_repository.dart';
import 'package:untitled1/features/product_compare/presentation/cubit/compare_session_cubit.dart';
import 'package:untitled1/features/product_compare/presentation/mappers/compare_spec_mapper.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/widgets/loader.dart';

Future<void> showCompareProductPicker({
  required BuildContext context,
  required CompareSlot slot,
}) async {
  final session = context.read<CompareSessionCubit>().state;
  final category = session.lockedCategory;

  if (slot == CompareSlot.second && (category == null || category.isEmpty)) {
    DataHelper.showSnackBar(
      context: context,
      message: 'compare_pick_first_hint',
    );
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (sheetContext) {
      return BlocProvider.value(
        value: context.read<CompareSessionCubit>(),
        child: _CompareProductPickerSheet(
          slot: slot,
          category: category,
        ),
      );
    },
  );
}

class _CompareProductPickerSheet extends StatefulWidget {
  final CompareSlot slot;
  final String? category;

  const _CompareProductPickerSheet({
    required this.slot,
    required this.category,
  });

  @override
  State<_CompareProductPickerSheet> createState() =>
      _CompareProductPickerSheetState();
}

class _CompareProductPickerSheetState extends State<_CompareProductPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CompareProductListItem> _products = [];
  bool _isLoading = true;
  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final session = context.read<CompareSessionCubit>().state;
    final exclude = <String>{
      if (session.firstProduct != null) session.firstProduct!.productId,
      if (session.secondProduct != null) session.secondProduct!.productId,
    };

    final result = await getIt<ProductCompareRepository>().getProducts(
      category: widget.category,
      excludeProductIds: exclude,
    );

    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _isLoading = false;
        _error = failure.message;
      }),
      (products) => setState(() {
        _isLoading = false;
        _products = products;
      }),
    );
  }

  List<CompareProductListItem> get _filteredProducts {
    if (_query.isEmpty) return _products;
    return _products.where((product) {
      return product.name.toLowerCase().contains(_query) ||
          product.storeName.toLowerCase().contains(_query);
    }).toList();
  }

  Future<void> _selectProduct(CompareProductListItem item) async {
    final cubit = context.read<CompareSessionCubit>();
    final result = await cubit.addProduct(
      businessId: item.businessId,
      productId: item.productId,
      storeName: item.storeName,
      forceSlot: widget.slot,
    );

    if (!mounted) return;

    if (result == CompareAddResult.addedToFirstSlot ||
        result == CompareAddResult.addedToSecondSlot) {
      Navigator.of(context).pop();
    } else if (result == CompareAddResult.loadFailed &&
        cubit.state.errorMessage != null) {
      DataHelper.showSnackBar(
        context: context,
        message: cubit.state.errorMessage!,
        color: AppColors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHeight = MediaQuery.of(context).size.height * 0.82;

    return SafeArea(
      child: SizedBox(
        height: maxHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'compare_pick_product'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.category == null
                        ? 'compare_pick_any_product'.tr()
                        : 'compare_category_locked'.tr(
                            namedArgs: {
                              'category': formatCompareCategoryLabel(
                                widget.category!,
                              ),
                            },
                          ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'compare_search_hint'.tr(),
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: switch (( _isLoading, _error, _filteredProducts.isEmpty)) {
                (true, _, _) => const Center(child: LoadingIndicator()),
                (false, final error?, _) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        error,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ),
                (false, null, true) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        'compare_no_products_found'.tr(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                _ => ListView.separated(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                    itemCount: _filteredProducts.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final item = _filteredProducts[index];
                      return _PickerProductTile(
                        item: item,
                        onTap: () => _selectProduct(item),
                      );
                    },
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerProductTile extends StatelessWidget {
  final CompareProductListItem item;
  final VoidCallback onTap;

  const _PickerProductTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = '\$${item.price.toStringAsFixed(2)}';

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: SizedBox(
                  width: 56.w,
                  height: 56.w,
                  child: item.imageUrl != null
                      ? ImageWidget(image: item.imageUrl!)
                      : ColoredBox(
                          color: Color(item.imagePlaceholderColorValue),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.storeName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                price,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> handleCompareFromProductDetail({
  required BuildContext context,
  required int businessId,
  required String productId,
  String? storeName,
}) async {
  final cubit = context.read<CompareSessionCubit>();
  final result = await cubit.addProduct(
    businessId: businessId,
    productId: productId,
    storeName: storeName,
  );

  if (!context.mounted) return;

  switch (result) {
    case CompareAddResult.addedToFirstSlot:
      _showAddedSnackBar(context, navigateIfReady: false);
    case CompareAddResult.addedToSecondSlot:
      _showAddedSnackBar(context, navigateIfReady: true);
    case CompareAddResult.alreadyInCompare:
      DataHelper.showSnackBar(
        context: context,
        message: 'compare_already_added',
      );
    case CompareAddResult.categoryMismatch:
      final shouldRestart = await _showCategoryMismatchDialog(context);
      if (shouldRestart && context.mounted) {
        context.read<CompareSessionCubit>().clear();
        await handleCompareFromProductDetail(
          context: context,
          businessId: businessId,
          productId: productId,
          storeName: storeName,
        );
      }
    case CompareAddResult.bothSlotsFull:
      await _showReplaceDialog(
        context: context,
        businessId: businessId,
        productId: productId,
        storeName: storeName,
      );
    case CompareAddResult.loadFailed:
      if (cubit.state.errorMessage != null) {
        DataHelper.showSnackBar(
          context: context,
          message: cubit.state.errorMessage!,
          color: AppColors.red,
        );
      }
  }
}

void _showAddedSnackBar(
  BuildContext context, {
  required bool navigateIfReady,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      behavior: SnackBarBehavior.floating,
      content: Text('compare_added_snackbar'.tr()),
      action: SnackBarAction(
        label: 'compare_view'.tr(),
        onPressed: () => context.push(AppRoutes.packageComparisonScreen),
      ),
    ),
  );

  if (navigateIfReady) {
    context.push(AppRoutes.packageComparisonScreen);
  }
}

Future<bool> _showCategoryMismatchDialog(BuildContext context) async {
  final shouldReplace = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('compare_category_mismatch_title'.tr()),
      content: Text('compare_category_mismatch'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text('cancel'.tr()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text('compare_replace'.tr()),
        ),
      ],
    ),
  );

  return shouldReplace ?? false;
}

Future<void> _showReplaceDialog({
  required BuildContext context,
  required int businessId,
  required String productId,
  String? storeName,
}) async {
  final slot = await showDialog<CompareSlot>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('compare_replace_title'.tr()),
      content: Text('compare_replace_prompt'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('cancel'.tr()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, CompareSlot.first),
          child: Text('compare_product_a'.tr()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, CompareSlot.second),
          child: Text('compare_product_b'.tr()),
        ),
      ],
    ),
  );

  if (slot == null || !context.mounted) return;

  final result = await context.read<CompareSessionCubit>().addProduct(
        businessId: businessId,
        productId: productId,
        storeName: storeName,
        forceSlot: slot,
      );

  if (!context.mounted) return;

  if (result == CompareAddResult.addedToFirstSlot ||
      result == CompareAddResult.addedToSecondSlot) {
    context.push(AppRoutes.packageComparisonScreen);
  }
}
