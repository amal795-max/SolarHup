import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

import '../../../../widgets/header_section.dart';
import '../widgets/category_chip.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/features/used_system/presentation/bloc/used_system_cubit.dart';
import 'package:untitled1/widgets/empty_widget.dart';

class UsedProductsScreen extends StatefulWidget {
  const UsedProductsScreen({super.key});

  @override
  State<UsedProductsScreen> createState() => _UsedProductsScreenState();
}

class _UsedProductsScreenState extends State<UsedProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UsedSystemCubit>().getUsedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () => context.read<UsedSystemCubit>().getUsedProducts(),
          child: Column(
            children: [
              headerSection(
                title: 'home_used_systems',
                subTitle: 'home_used_system_desc',
              ),
              SizedBox(height: 16.h),
              const _SearchAndFilterRow(),
              const CategoryFilterSection(),
              Expanded(
                child: BlocBuilder<UsedSystemCubit, UsedSystemState>(
                  buildWhen: (previous, current) =>
                      current is UsedProductsLoading ||
                      current is UsedProductsSuccess ||
                      current is UsedProductsFailure,
                  builder: (context, state) {
                    if (state is UsedProductsFailure) {
                      return Center(child: Text(state.message));
                    }

                    final isLoading = state is UsedProductsLoading;
                    final products = state is UsedProductsSuccess
                        ? state.products
                        : List.generate(
                            6,
                            (index) => UsedProductModel(
                              id: 0,
                              sellerId: 0,
                              sellerPhone: '',
                              name: 'Loading product...',
                              description: '',
                              category: '',
                              condition: 'new',
                              price: '0.00',
                              region: 'Loading...',
                              status: 'active',
                              images: [],
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                          );

                    if (state is UsedProductsSuccess && products.isEmpty) {
                      return const EmptyWidget(subtitle: '');
                    }

                    return Skeletonizer(
                      enabled: isLoading,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            _ProductGrid(products: products),
                            SizedBox(height: 100.h),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: const _SellSystemButton(),
      ),
    );
  }
}

class _SearchAndFilterRow extends StatelessWidget {
  const _SearchAndFilterRow();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsedSystemCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              title: 'title',
              hasTitle: false,
              hint: 'search_hint'.tr(),
              prefixIcon: const Icon(Icons.search, color: AppColors.grey),
              onChanged: (value) {
                cubit.getUsedProducts();
              },
            ),
          ),
          SizedBox(width: 12.w),
          InkWell(
            onTap: () {
              context.push(AppRoutes.filterProductScreen);
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.tune, color: Colors.white, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<UsedProductModel> products;

  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(product: products[index]);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final UsedProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.usedProductDetailScreen, extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                    ),
                    child: product.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.r),
                            ),
                            child: Image.network(
                              product.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported, size: 40.sp),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.battery_std,
                              size: 40.sp,
                              color: AppColors.grey,
                            ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        product.condition.tr(),
                        style: AppStyle.labelSmall.copyWith(
                          color: AppColors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppStyle.bodyMedium.copyWith(fontSize: 12.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12.sp,
                        color: AppColors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          product.region,
                          style: AppStyle.bodySmall.copyWith(fontSize: 10.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '\$${product.price}',
                    style: AppStyle.bodyMedium.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(children: [_Tag(label: product.category.tr())]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppStyle.bodySmall.copyWith(
          fontSize: 8.sp,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

class _SellSystemButton extends StatelessWidget {
  const _SellSystemButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        context.push(AppRoutes.addProductScreen);
      },
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: AppColors.brown,
      label: Text(
        'sell_your_system'.tr(),
        style: AppStyle.labelSmall.copyWith(color: AppColors.brown),
      ),
      icon: const Icon(Icons.add_circle_outline),
    );
  }
}
