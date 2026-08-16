import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/features/used_system/presentation/bloc/used_system_cubit.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/header_section.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/empty_widget.dart';
import '../widgets/badge_product_status.dart';
import 'add_used_system/add_used_product_screen.dart';

class MyListingScreen extends StatelessWidget {
  const MyListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerSection(
              title: 'my_listings',
              subTitle: 'manage_listings_subtitle',
            ),
            Expanded(
              child: BlocConsumer<UsedSystemCubit, UsedSystemState>(
                listener: _listener,
                listenWhen: _listenWhen,

                builder: _builder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listener(BuildContext context, UsedSystemState state) {
    if (state is DeleteProductSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
    if (state is DeleteProductFailure) {
      DataHelper.showSnackBar(
        message: state.message,
        context: context,
        color: AppColors.red,
      );
    }
    if (state is UpdateProductStatusSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
    if (state is UpdateProductStatusFailure) {
      DataHelper.showSnackBar(
        message: state.message,
        context: context,
        color: AppColors.red,
      );
    }
  }

  bool _listenWhen(UsedSystemState previous, UsedSystemState current) =>
      (current is UpdateProductStatusFailure) ||
      (current is UpdateProductStatusSuccess) ||
      (current is DeleteProductFailure) ||
      (current is DeleteProductSuccess);

  Widget _builder(BuildContext context, UsedSystemState state) {
    if (state is DeleteProductLoading || state is UpdateProductStatusLoading) {
      return const LoadingIndicator();
    }
    if (state is MyUsedProductsFailure) {
      return EmptyWidget(
        icon: Icons.error_outline,
        iconSize: 56,
        iconColor: AppColors.grey,
        title: 'stores_error_title',
        subtitle: state.message,
        action: CustomButton(
          text: 'stores_retry'.tr(),
          icon: Icons.refresh_rounded,
          iconLeft: true,
          onPressed: () => context.read<UsedSystemCubit>().getMyUsedProducts(),
        ),
      );
    }
    final isLoading = state is MyUsedProductsLoading;
    final List<UsedProductModel> products = isLoading
        ? List.generate(
            4,
            (index) => UsedProductModel(
              id: 0,
              sellerId: 0,
              sellerPhone: '',
              name: 'Loading...',
              description: 'Loading...',
              category: '',
              condition: '',
              price: '',
              region: '',
              status: 'active',
              images: [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          )
        : context.read<UsedSystemCubit>().myProducts;

    if (!isLoading && products.isEmpty) {
      return AppRefreshIndicator(
        onRefresh: () => context.read<UsedSystemCubit>().getMyUsedProducts(),
        child: ListView(
          physics: appRefreshPhysics,
          children: const [EmptyWidget()],
        ),
      );
    }

    return AppRefreshIndicator(
      onRefresh: () => context.read<UsedSystemCubit>().getMyUsedProducts(),
      child: Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        physics: appRefreshPhysics,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemCount: products.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          return _ListingCard(product: products[index])
              .animate()
              .fadeIn(duration: 400.ms, delay: (index * 100).ms)
              .slideX(begin: 0.2, end: 0);
        },
      ),
    ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final UsedProductModel product;

  const _ListingCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: AppColors.backGroundGrey,
                    borderRadius: BorderRadius.circular(12.r),
                    image: product.images.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(product.images.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: product.images.isEmpty
                      ? Icon(Icons.inventory_2_outlined, size: 40.sp)
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: AppStyle.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          StatusUsedBadge(status: product.status),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        product.description,
                        style: AppStyle.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        '${product.price} USD',
                        style: AppStyle.bodyMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _ActionButtons(product: product),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final UsedProductModel product;

  const _ActionButtons({required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.status == 'sold') {
      return Padding(
        padding: EdgeInsets.all(12.w),
        child: CustomButton(
          type: ButtonType.outlined,
          textColor: AppColors.red,
          borderColor: AppColors.red,
          text: 'delete'.tr(),
          height: 40,
          onPressed: () {
            DataHelper().showConfirmationDialog(
              context,
              'delete_listing',
              'delete_listing_confirm',
              () {
                context.read<UsedSystemCubit>().deleteProduct(product.id);
                Navigator.pop(context);
              },
            );
          },
          icon: Icons.delete_outline,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomButton(
              text: 'edit'.tr(),
              height: 40,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddUsedProductScreen(product: product),
                  ),
                );
              },
              icon: Icons.mode_edit_outline_outlined,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: CustomButton(
              text: 'mark_as_sold'.tr(),
              height: 40,
              onPressed: () {
                context.read<UsedSystemCubit>().updateProductStatus(
                  product.id,
                  'sold',
                );
              },
              icon: Icons.check_circle_outline,
              type: ButtonType.outlined,
            ),
          ),
          SizedBox(width: 8.w),
          _DeleteButton(
            onPressed: () {
              DataHelper().showConfirmationDialog(
                context,
                'delete_listing',
                'delete_listing_confirm',
                () {
                  context.read<UsedSystemCubit>().deleteProduct(product.id);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 40.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.red.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.delete_outline, color: AppColors.red, size: 20.sp),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
